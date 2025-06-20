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
import { LibStub } from '../src/helper/LibStub.sol';
import { LibStubERC20 } from '../src/helper/LibStubERC20.sol';

contract StubTest is Test {
  using LibStub for address;
  using LibStubERC20 for address;

  address stub;

  address alice = makeAddr('alice');
  address bob = makeAddr('bob');

  function setUp() public {
    stub = address(new Stub('TestERC20'));
    stub.initStubERC20('Test', 'TST', 18);
  }

  function test_init() public {
    assertEq(stub.manager().name(), 'TestERC20');

    vm.startPrank(alice);

    IERC20Metadata erc20 = IERC20Metadata(stub);
    assertEq(erc20.name(), 'Test');
    assertEq(erc20.symbol(), 'TST');
    assertEq(erc20.decimals(), 18);

    vm.stopPrank();
  }

  function test_version() public view {
    assertEq(Stub(payable(stub)).GIT_TAG(), '{{git_tag}}');
    assertEq(Stub(payable(stub)).GIT_COMMIT(), '{{git_commit}}');
  }

  function test_call_simple() public {
    stub.setRetERC20Transfer(bob, 100);

    vm.startPrank(alice);

    IERC20Metadata erc20 = IERC20Metadata(stub);

    erc20.transfer(bob, 100);

    vm.stopPrank();

    stub.inspector().expectOk(IERC20.transfer.selector);
    stub.inspector().expectOk(abi.encodeCall(IERC20.transfer, (bob, 100)));
    assertEq(stub.inspector().getCallCount(IERC20.transfer.selector), 1);
    assertEq(stub.inspector().getCallCount(abi.encodeCall(IERC20.transfer, (bob, 100))), 1);
    assertEq(stub.inspector().getCallCount(abi.encodeCall(IERC20.transfer, (bob, 200))), 0);
  }

  function test_staticcall_simple() public {
    stub.setRetERC20BalanceOf(bob, 100);

    vm.startPrank(alice);

    IERC20Metadata erc20 = IERC20Metadata(stub);
    erc20.balanceOf(bob);

    vm.stopPrank();

    vm.expectRevert(_errNotRegistered(IERC20.balanceOf.selector, 'balanceOf'));
    stub.inspector().expectOk(IERC20.balanceOf.selector);

    vm.expectRevert(_errNotRegistered(IERC20.balanceOf.selector, 'balanceOf'));
    assertEq(stub.inspector().getCallCount(IERC20.balanceOf.selector), 0);

    vm.expectRevert(_errNotRegistered(IERC20.balanceOf.selector, 'balanceOf'));
    assertEq(stub.inspector().getCallCount(abi.encodeCall(IERC20.balanceOf, (bob))), 0);
  }

  function test_call_bubbling() public {
    bytes memory calldata_ = abi.encodeWithSignature('asdf(string)', 'input');
    stub.manager().setOk(calldata_, abi.encode('output'));

    // call 'asdf' with the account who has inspector and manager roles
    (bool ok, bytes memory ret) = stub.call(calldata_);
    assertEq(ok, true);
    assertEq(ret, abi.encode('output'));
  }

  function _errNotRegistered(bytes4 sig, string memory name) internal pure returns (bytes memory) {
    return abi.encodeWithSelector(IStubErrors.NotRegistered.selector, sig, name);
  }
}
