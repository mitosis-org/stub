# Stub

A contract that allows you to stub function calls.

## List of Helpers

- [ERC20](./src/helper/LibStubERC20.sol)
- [ERC4626](./src/helper/LibStubERC4626.sol)

## Usage

```solidity

import { Test } from '@std/Test.sol';

import { Stub } from '@stub/Stub.sol';
import { LibStubERC20 } from '@stub/helper/LibStubERC20.sol';

import { IERC20 } from '@oz/interfaces/IERC20.sol';
import { IERC20Metadata } from '@oz/interfaces/IERC20Metadata.sol';

contract A is Test {
  using LibStubERC20 for address;

  address alice = makeAddr('alice');

  address stub;
  IERC20Metadata erc20;

  function setUp() public {
    stub = address(new Stub('Test'));
    stub.initStubERC20('Test', 'TST', 18);

    erc20 = IERC20Metadata(stub);
  }

  function test_init() public {
    vm.startPrank(alice);

    assertEq(erc20.name(), 'Test');
    assertEq(erc20.symbol(), 'TST');
    assertEq(erc20.decimals(), 18);

    vm.stopPrank();
  }

  function test_call_simple() public {
    stub.setRetERC20Transfer(bob, 100);

    vm.prank(alice);
    erc20.transfer(bob, 100);

    stubI.expectOk(IERC20.transfer.selector);
    stubI.expectOk(abi.encodeCall(IERC20.transfer, (bob, 100)));
    assertEq(stubI.getCallCount(IERC20.transfer.selector), 1);
    assertEq(stubI.getCallCount(abi.encodeCall(IERC20.transfer, (bob, 100))), 1);
    assertEq(stubI.getCallCount(abi.encodeCall(IERC20.transfer, (bob, 200))), 0);
  }
}

```
