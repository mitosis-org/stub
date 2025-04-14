// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { console } from '@std/console.sol';
import { Test } from '@std/Test.sol';

import { IERC20 } from '@oz/interfaces/IERC20.sol';
import { IERC20Metadata } from '@oz/interfaces/IERC20Metadata.sol';

import { Stub } from '../src/Stub.sol';
import { StubManager } from '../src/impl/StubManager.sol';
import { StubExecutor } from '../src/impl/StubExecutor.sol';
import { StubInspector } from '../src/impl/StubInspector.sol';

import { IStubErrors } from '../src/interface/IStubErrors.sol';
import { IStubViewer } from '../src/interface/IStubViewer.sol';
import { IStubManager } from '../src/interface/IStubManager.sol';
import { IStubInspector } from '../src/interface/IStubInspector.sol';
import { LibStubERC20 } from '../src/helper/LibStubERC20.sol';

contract DeployStub {
  function deploy(string calldata name) external returns (address) {
    Stub stub = new Stub(
      name,
      msg.sender,
      msg.sender, //
      address(new StubManager()),
      address(new StubExecutor()),
      address(new StubInspector())
    );

    return address(stub);
  }
}

contract StubTest is Test {
  using LibStubERC20 for address;

  DeployStub deployer;
  address stub;

  address alice = makeAddr('alice');
  address bob = makeAddr('bob');

  function setUp() public {
    deployer = new DeployStub();
    stub = deployer.deploy('TestERC20');
    stub.initStubERC20('Test', 'TST', 18);
  }

  function test_init() public {
    assertEq(IStubViewer(stub).name(), 'TestERC20');

    vm.startPrank(alice);

    IERC20Metadata erc20 = IERC20Metadata(stub);
    assertEq(erc20.name(), 'Test');
    assertEq(erc20.symbol(), 'TST');
    assertEq(erc20.decimals(), 18);

    vm.stopPrank();
  }

  function test_call_simple() public {
    stub.setRetERC20Transfer(bob, 100);

    vm.startPrank(alice);

    IERC20Metadata erc20 = IERC20Metadata(stub);

    erc20.transfer(bob, 100);

    vm.stopPrank();

    IStubInspector stubI = IStubInspector(stub);
    stubI.expectOk(IERC20.transfer.selector);
    assertEq(stubI.getCallCount(IERC20.transfer.selector), 1);
    assertEq(stubI.getCallCount(abi.encodeCall(IERC20.transfer, (bob, 100))), 1);
    assertEq(stubI.getCallCount(abi.encodeCall(IERC20.transfer, (bob, 200))), 0);
  }

  function test_staticcall_simple() public {
    stub.setRetERC20BalanceOf(bob, 100);

    vm.startPrank(alice);

    IERC20Metadata erc20 = IERC20Metadata(stub);
    erc20.balanceOf(bob);

    vm.stopPrank();

    IStubInspector stubI = IStubInspector(stub);
    vm.expectRevert(_errNotACall(IERC20.balanceOf.selector, 'balanceOf'));
    stubI.expectOk(IERC20.balanceOf.selector);

    vm.expectRevert(_errNotACall(IERC20.balanceOf.selector, 'balanceOf'));
    assertEq(stubI.getCallCount(IERC20.balanceOf.selector), 0);

    vm.expectRevert(_errNotACall(IERC20.balanceOf.selector, 'balanceOf'));
    assertEq(stubI.getCallCount(abi.encodeCall(IERC20.balanceOf, (bob))), 0);
  }

  function test_call_bubbling() public {
    bytes memory calldata_ = abi.encodeWithSignature('asdf(string)', 'input');
    IStubManager(stub).setOk(calldata_, abi.encode('output'));

    // call 'asdf' with the account who has inspector and manager roles
    (bool ok, bytes memory ret) = stub.call(calldata_);
    assertEq(ok, true);
    assertEq(ret, abi.encode('output'));
  }

  function _errNotACall(bytes4 sig, string memory name) internal pure returns (bytes memory) {
    return abi.encodeWithSelector(IStubErrors.NotACall.selector, sig, name);
  }
}
