// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { IERC20 } from '@oz/interfaces/IERC20.sol';
import { IERC20Metadata } from '@oz/interfaces/IERC20Metadata.sol';

import { IStubManager } from '../interface/IStubManager.sol';
import { IStubInspector } from '../interface/IStubInspector.sol';

import { LibStub } from './LibStub.sol';

library LibStubERC20 {
  using LibStub for address;

  function initStubERC20(address stub, string memory name, string memory symbol, uint8 decimals) internal {
    stub.manager().regF(IERC20.transfer.selector, true, 'transfer');
    stub.manager().regF(IERC20.transferFrom.selector, true, 'transferFrom');
    stub.manager().regF(IERC20.approve.selector, true, 'approve');

    stub.manager().regF(IERC20.allowance.selector, false, 'allowance');
    stub.manager().regF(IERC20.balanceOf.selector, false, 'balanceOf');
    stub.manager().regF(IERC20.totalSupply.selector, false, 'totalSupply');

    stub.manager().setOk(IERC20Metadata.name.selector, abi.encode(name));
    stub.manager().setOk(IERC20Metadata.symbol.selector, abi.encode(symbol));
    stub.manager().setOk(IERC20Metadata.decimals.selector, abi.encode(decimals));
  }

  // ================================================= VIEW FUNCTIONS ================================================= //

  function setRetERC20Allowance(address stub, address owner, address spender, uint256 amount)
    internal
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC20.allowance, (owner, spender));
    stub.manager().setOk(data, abi.encode(amount));
    return stub;
  }

  function setRetERC20BalanceOf(address stub, address account, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.balanceOf, (account));
    stub.manager().setOk(data, abi.encode(amount));
    return stub;
  }

  function setRetERC20TotalSupply(address stub, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.totalSupply, ());
    stub.manager().setOk(data, abi.encode(amount));
    return stub;
  }

  // ================================================= MUTATIVE FUNCTIONS ================================================= //

  function setRetERC20Transfer(address stub, address to, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.transfer, (to, amount));
    stub.manager().setOk(data, abi.encode(true));
    return stub;
  }

  function setRetERC20TransferFrom(address stub, address from, address to, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.transferFrom, (from, to, amount));
    stub.manager().setOk(data, abi.encode(true));
    return stub;
  }

  function setRetERC20Approve(address stub, address spender, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.approve, (spender, amount));
    stub.manager().setOk(data, abi.encode(true));
    return stub;
  }

  function assertERC20Transfer(address stub, address to, uint256 amount) internal view returns (address) {
    bytes memory data = abi.encodeCall(IERC20.transfer, (to, amount));
    stub.inspector().expectOk(data);
    return stub;
  }

  function assertERC20TransferFrom(address stub, address from, address to, uint256 amount)
    internal
    view
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC20.transferFrom, (from, to, amount));
    stub.inspector().expectOk(data);
    return stub;
  }

  function assertERC20Approve(address stub, address spender, uint256 amount) internal view returns (address) {
    bytes memory data = abi.encodeCall(IERC20.approve, (spender, amount));
    stub.inspector().expectOk(data);
    return stub;
  }
}
