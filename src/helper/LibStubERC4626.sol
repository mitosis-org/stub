// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { IERC4626 } from '@oz/interfaces/IERC4626.sol';
import { IStubManager } from '../interface/IStubManager.sol';
import { IStubInspector } from '../interface/IStubInspector.sol';
import { LibStubERC20 } from './LibStubERC20.sol';

library LibStubERC4626 {
  using LibStubERC20 for address;

  function _tom(address stub) private pure returns (IStubManager) {
    return IStubManager(stub);
  }

  function _toi(address stub) private pure returns (IStubInspector) {
    return IStubInspector(stub);
  }

  function initStubERC4626(address stub, string memory name, string memory symbol, uint8 decimals) internal {
    stub.initStubERC20(name, symbol, decimals);

    _tom(stub).regF(IERC4626.deposit.selector, true, 'deposit');
    _tom(stub).regF(IERC4626.mint.selector, true, 'mint');
    _tom(stub).regF(IERC4626.withdraw.selector, true, 'withdraw');
    _tom(stub).regF(IERC4626.redeem.selector, true, 'redeem');

    _tom(stub).regF(IERC4626.asset.selector, false, 'asset');
    _tom(stub).regF(IERC4626.totalAssets.selector, false, 'totalAssets');
    _tom(stub).regF(IERC4626.convertToShares.selector, false, 'convertToShares');
    _tom(stub).regF(IERC4626.convertToAssets.selector, false, 'convertToAssets');
    _tom(stub).regF(IERC4626.maxDeposit.selector, false, 'maxDeposit');
    _tom(stub).regF(IERC4626.maxMint.selector, false, 'maxMint');
    _tom(stub).regF(IERC4626.maxWithdraw.selector, false, 'maxWithdraw');
    _tom(stub).regF(IERC4626.maxRedeem.selector, false, 'maxRedeem');
    _tom(stub).regF(IERC4626.previewDeposit.selector, false, 'previewDeposit');
    _tom(stub).regF(IERC4626.previewMint.selector, false, 'previewMint');
    _tom(stub).regF(IERC4626.previewWithdraw.selector, false, 'previewWithdraw');
    _tom(stub).regF(IERC4626.previewRedeem.selector, false, 'previewRedeem');
  }

  // ================================================= VIEW FUNCTIONS ================================================= //

  function setRetERC4626Asset(address stub, address asset) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.asset, ());
    _tom(stub).setOk(data, abi.encode(asset));
    return stub;
  }

  function setRetERC4626TotalAssets(address stub, uint256 totalAssets) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.totalAssets, ());
    _tom(stub).setOk(data, abi.encode(totalAssets));
    return stub;
  }

  function setRetERC4626ConvertToShares(address stub, uint256 assets, uint256 shares) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.convertToShares, (assets));
    _tom(stub).setOk(data, abi.encode(shares));
    return stub;
  }

  function setRetERC4626ConvertToAssets(address stub, uint256 shares, uint256 assets) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.convertToAssets, (shares));
    _tom(stub).setOk(data, abi.encode(assets));
    return stub;
  }

  function setRetERC4626MaxDeposit(address stub, address receiver, uint256 maxAssets) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.maxDeposit, (receiver));
    _tom(stub).setOk(data, abi.encode(maxAssets));
    return stub;
  }

  function setRetERC4626MaxMint(address stub, address receiver, uint256 maxShares) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.maxMint, (receiver));
    _tom(stub).setOk(data, abi.encode(maxShares));
    return stub;
  }

  function setRetERC4626MaxWithdraw(address stub, address owner, uint256 maxAssets) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.maxWithdraw, (owner));
    _tom(stub).setOk(data, abi.encode(maxAssets));
    return stub;
  }

  function setRetERC4626MaxRedeem(address stub, address owner, uint256 maxShares) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.maxRedeem, (owner));
    _tom(stub).setOk(data, abi.encode(maxShares));
    return stub;
  }

  function setRetERC4626PreviewDeposit(address stub, uint256 assets, uint256 shares) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.previewDeposit, (assets));
    _tom(stub).setOk(data, abi.encode(shares));
    return stub;
  }

  function setRetERC4626PreviewMint(address stub, uint256 shares, uint256 assets) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.previewMint, (shares));
    _tom(stub).setOk(data, abi.encode(assets));
    return stub;
  }

  function setRetERC4626PreviewWithdraw(address stub, uint256 assets, uint256 shares) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.previewWithdraw, (assets));
    _tom(stub).setOk(data, abi.encode(shares));
    return stub;
  }

  function setRetERC4626PreviewRedeem(address stub, uint256 shares, uint256 assets) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.previewRedeem, (shares));
    _tom(stub).setOk(data, abi.encode(assets));
    return stub;
  }

  // ================================================= MUTATIVE FUNCTIONS ================================================= //

  function setRetERC4626Deposit(address stub, uint256 assets, address receiver, uint256 shares)
    internal
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC4626.deposit, (assets, receiver));
    _tom(stub).setOk(data, abi.encode(shares));
    return stub;
  }

  function assertERC4626Deposit(address stub, uint256 assets, address receiver) internal view returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.deposit, (assets, receiver));
    _toi(stub).expectOk(data);
    return stub;
  }

  function setRetERC4626Mint(address stub, uint256 shares, address receiver, uint256 assets) internal returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.mint, (shares, receiver));
    _tom(stub).setOk(data, abi.encode(assets));
    return stub;
  }

  function assertERC4626Mint(address stub, uint256 shares, address receiver) internal view returns (address) {
    bytes memory data = abi.encodeCall(IERC4626.mint, (shares, receiver));
    _toi(stub).expectOk(data);
    return stub;
  }

  function setRetERC4626Withdraw(address stub, uint256 assets, address receiver, address owner, uint256 shares)
    internal
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC4626.withdraw, (assets, receiver, owner));
    _tom(stub).setOk(data, abi.encode(shares));
    return stub;
  }

  function assertERC4626Withdraw(address stub, uint256 assets, address receiver, address owner)
    internal
    view
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC4626.withdraw, (assets, receiver, owner));
    _toi(stub).expectOk(data);
    return stub;
  }

  function setRetERC4626Redeem(address stub, uint256 shares, address receiver, address owner, uint256 assets)
    internal
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC4626.redeem, (shares, receiver, owner));
    _tom(stub).setOk(data, abi.encode(assets));
    return stub;
  }

  function assertERC4626Redeem(address stub, uint256 shares, address receiver, address owner)
    internal
    view
    returns (address)
  {
    bytes memory data = abi.encodeCall(IERC4626.redeem, (shares, receiver, owner));
    _toi(stub).expectOk(data);
    return stub;
  }
}
