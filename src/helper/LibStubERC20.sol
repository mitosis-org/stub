// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { IERC20 } from '@oz/interfaces/IERC20.sol';
import { IERC20Metadata } from '@oz/interfaces/IERC20Metadata.sol';

import { IStubManager } from '../interface/IStubManager.sol';
import { IStubInspector } from '../interface/IStubInspector.sol';

library LibStubERC20 {
  function _tom(address stub) private pure returns (IStubManager) {
    return IStubManager(stub);
  }

  function _toi(address stub) private pure returns (IStubInspector) {
    return IStubInspector(stub);
  }

  function initStubERC20(address stub, string memory name, string memory symbol, uint8 decimals) internal {
    _tom(stub).regF(IERC20.transfer.selector, true, 'transfer');
    _tom(stub).regF(IERC20.transferFrom.selector, true, 'transferFrom');
    _tom(stub).regF(IERC20.approve.selector, true, 'approve');

    _tom(stub).regF(IERC20.allowance.selector, false, 'allowance');
    _tom(stub).regF(IERC20.balanceOf.selector, false, 'balanceOf');
    _tom(stub).regF(IERC20.totalSupply.selector, false, 'totalSupply');

    _tom(stub).setOk(IERC20Metadata.name.selector, abi.encode(name));
    _tom(stub).setOk(IERC20Metadata.symbol.selector, abi.encode(symbol));
    _tom(stub).setOk(IERC20Metadata.decimals.selector, abi.encode(decimals));
  }

  // ================================================= VIEW FUNCTIONS ================================================= //

  function setRetERC20Allowance(address stub, address owner, address spender, uint256 amount)
    internal
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC20.allowance, (owner, spender));
    _tom(stub).setOk(data, abi.encode(amount));
    return stub;
  }

  function setRetERC20BalanceOf(address stub, address account, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.balanceOf, (account));
    _tom(stub).setOk(data, abi.encode(amount));
    return stub;
  }

  function setRetERC20TotalSupply(address stub, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.totalSupply, ());
    _tom(stub).setOk(data, abi.encode(amount));
    return stub;
  }

  // ================================================= MUTATIVE FUNCTIONS ================================================= //

  function setRetERC20Transfer(address stub, address to, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.transfer, (to, amount));
    _tom(stub).setOk(data, abi.encode(true));
    return stub;
  }

  function setRetERC20TransferFrom(address stub, address from, address to, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.transferFrom, (from, to, amount));
    _tom(stub).setOk(data, abi.encode(true));
    return stub;
  }

  function setRetERC20Approve(address stub, address spender, uint256 amount) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC20.approve, (spender, amount));
    _tom(stub).setOk(data, abi.encode(true));
    return stub;
  }

  function assertERC20Transfer(address stub, address to, uint256 amount) internal view returns (address) {
    bytes memory data = abi.encodeCall(IERC20.transfer, (to, amount));
    _toi(stub).expectOk(data);
    return stub;
  }

  function assertERC20TransferFrom(address stub, address from, address to, uint256 amount)
    internal
    view
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC20.transferFrom, (from, to, amount));
    _toi(stub).expectOk(data);
    return stub;
  }

  function assertERC20Approve(address stub, address spender, uint256 amount) internal view returns (address) {
    bytes memory data = abi.encodeCall(IERC20.approve, (spender, amount));
    _toi(stub).expectOk(data);
    return stub;
  }
}
