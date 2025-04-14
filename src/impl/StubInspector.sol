// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IStubErrors } from '../interface/IStubErrors.sol';
import { IStubInspector } from '../interface/IStubInspector.sol';
import { StubViewer } from './StubViewer.sol';
import { Printer } from '../lib/Printer.sol';

contract StubInspector is IStubInspector, StubViewer {
  using Printer for Func;

  // ================================================
  // Ok
  // ================================================

  function expectOk(bytes4 sig) external view onlyProxy returns (Ret memory) {
    return _expect(0, sig, false, 0);
  }

  function expectOk(bytes4 sig, uint256 value) external view onlyProxy returns (Ret memory) {
    return _expect(0, sig, false, value);
  }

  function expectOk(bytes calldata data) external view onlyProxy returns (Ret memory) {
    return _expect(0, data, false, 0);
  }

  function expectOk(bytes calldata data, uint256 value) external view onlyProxy returns (Ret memory) {
    return _expect(0, data, false, value);
  }

  function expectOk(uint256 offset, bytes4 sig) external view onlyProxy returns (Ret memory) {
    return _expect(offset, sig, false, 0);
  }

  function expectOk(uint256 offset, bytes4 sig, uint256 value) external view onlyProxy returns (Ret memory) {
    return _expect(offset, sig, false, value);
  }

  function expectOk(uint256 offset, bytes calldata data) external view onlyProxy returns (Ret memory) {
    return _expect(offset, data, false, 0);
  }

  function expectOk(uint256 offset, bytes calldata data, uint256 value) external view onlyProxy returns (Ret memory) {
    return _expect(offset, data, false, value);
  }

  // ================================================
  // Fail
  // ================================================

  function expectFail(bytes4 sig) external view onlyProxy returns (Ret memory) {
    return _expect(0, sig, true, 0);
  }

  function expectFail(bytes4 sig, uint256 value) external view onlyProxy returns (Ret memory) {
    return _expect(0, sig, true, value);
  }

  function expectFail(bytes calldata data) external view onlyProxy returns (Ret memory) {
    return _expect(0, data, true, 0);
  }

  function expectFail(bytes calldata data, uint256 value) external view onlyProxy returns (Ret memory) {
    return _expect(0, data, true, value);
  }

  function expectFail(uint256 offset, bytes4 sig) external view onlyProxy returns (Ret memory) {
    return _expect(offset, sig, true, 0);
  }

  function expectFail(uint256 offset, bytes4 sig, uint256 value) external view onlyProxy returns (Ret memory) {
    return _expect(offset, sig, true, value);
  }

  function expectFail(uint256 offset, bytes calldata data) external view onlyProxy returns (Ret memory) {
    return _expect(offset, data, true, 0);
  }

  function expectFail(uint256 offset, bytes calldata data, uint256 value) external view onlyProxy returns (Ret memory) {
    return _expect(offset, data, true, value);
  }

  // ================================================
  // Private
  // ================================================

  function _expect(uint256 offset, bytes4 sig, bool revert_, uint256 value) internal view returns (Ret memory) {
    StorageV1 storage $ = _getStorageV1();
    Log memory log = _getCall($, offset, sig);

    if (log.ret.revert_ != revert_) _revertNotMatchedBySig($, sig, revert_, value, log);
    if (log.value != value) _revertNotMatchedBySig($, sig, revert_, value, log);

    return log.ret;
  }

  function _expect(uint256 offset, bytes calldata data, bool revert_, uint256 value) internal view returns (Ret memory) {
    StorageV1 storage $ = _getStorageV1();
    Log memory log = _getCall($, offset, data);

    if (log.ret.revert_ != revert_) _revertNotMatchedByArgs($, data, revert_, value, log);
    if (log.value != value) _revertNotMatchedByArgs($, data, revert_, value, log);

    return log.ret;
  }

  function _doBeforeRevert(StorageV1 storage $, bytes4 sig) internal view {
    $.funcs[sig].print('', 0);
  }

  function _revertNotMatchedByArgs(
    StorageV1 storage $,
    bytes calldata data,
    bool revert_,
    uint256 value,
    Log memory actual
  ) internal view {
    _doBeforeRevert($, bytes4(data[:4]));
    revert IStubErrors.NotMatchedByArgs(data, revert_, value, actual);
  }

  function _revertNotMatchedBySig(
    StorageV1 storage $, //
    bytes4 sig,
    bool revert_,
    uint256 value,
    Log memory actual
  ) internal view {
    _doBeforeRevert($, sig);
    revert IStubErrors.NotMatchedBySig(sig, revert_, value, actual);
  }
}
