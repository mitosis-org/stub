# Stub

A contract that allows you to stub function calls.

## Usage

```solidity

import { Test } from '@std/Test.sol';

import { Stub } from '@stub/Stub.sol';
import { IStubManager } from '@stub/interface/IStubManager.sol';
import { IStubInspector } from '@stub/interface/IStubInspector.sol';

import { IERC20 } from '@oz/interfaces/IERC20.sol';

contract A is Test {
  address alice = makeAddr('alice');

  address stub;
  IStubManager stubM;
  IStubInspector stubI;

  function setUp() public {
    stub = address(new Stub('Test'));
    stubM = IStubManager(stub);
    stubI = IStubInspector(stub);
  }

  function test_simple() public {
    stubM.setOk(abi.encodeCall(IERC20.transfer, (bob, 100)), abi.encode(true));

    vm.startPrank(alice);

    IERC20 erc20 = IERC20(stub);
    erc20.transfer(bob, 100);

    vm.stopPrank();

    stubI.expectOk(abi.encodeCall(IERC20.transfer, (bob, 100)));
    assertEq(stubI.getCallCount(abi.encodeCall(IERC20.transfer, (bob, 100))), 1);
  }
}

```
