// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { StubStorage } from '../shared/StubStorage.sol';
import { IStubViewer } from '../interface/IStubViewer.sol';

import { StubImplBase } from './StubImplBase.sol';

abstract contract StubViewer is IStubViewer, StubImplBase, StubStorage {
  function name() external view onlyProxy returns (string memory) {
    return _getStorageV1().name;
  }

  function getManager() external view onlyProxy returns (address) {
    return _getStorageV1().manager;
  }

  function getInspector() external view onlyProxy returns (address) {
    return _getStorageV1().inspector;
  }

  function getManagerImpl() external view onlyProxy returns (address) {
    return _getStorageV1().managerImpl;
  }

  function getExecutorImpl() external view onlyProxy returns (address) {
    return _getStorageV1().executorImpl;
  }

  function getInspectorImpl() external view onlyProxy returns (address) {
    return _getStorageV1().inspectorImpl;
  }

  function getCall(bytes4 sig) external view onlyProxy returns (Log memory) {
    return _getCall(_getStorageV1(), 0, sig);
  }

  function getCall(uint256 offset, bytes4 sig) external view onlyProxy returns (Log memory) {
    return _getCall(_getStorageV1(), offset, sig);
  }

  function getCall(bytes calldata data) external view onlyProxy returns (Log memory) {
    return _getCall(_getStorageV1(), 0, data);
  }

  function getCall(uint256 offset, bytes calldata data) external view onlyProxy returns (Log memory) {
    return _getCall(_getStorageV1(), offset, data);
  }

  function getCallCount(bytes4 sig) external view onlyProxy returns (uint256) {
    Func storage func = _getStorageV1().funcs[sig];
    require(func.isCall, NotACall(sig, func.name));
    return func.call_.logs.length;
  }

  function getCallCount(bytes calldata data) external view onlyProxy returns (uint256) {
    Func storage func = _getStorageV1().funcs[bytes4(data[0:4])];
    require(func.isCall, NotACall(bytes4(data[0:4]), func.name));
    return func.call_.byArgs[data[4:]].length;
  }

  function _getCall(StorageV1 storage $, uint256 offset, bytes4 sig) internal view returns (Log memory) {
    Func storage func = $.funcs[sig];
    require(func.isCall, NotACall(sig, func.name));

    Log[] storage logs = func.call_.logs;
    require(logs.length > 0, NoCalls(sig));

    return logs[logs.length - 1 - offset];
  }

  function _getCall(StorageV1 storage $, uint256 offset, bytes calldata data) internal view returns (Log memory) {
    Func storage func = $.funcs[bytes4(data[0:4])];
    require(func.isCall, NotACall(bytes4(data[0:4]), func.name));

    Log[] storage logs = func.call_.logs;
    uint256[] storage ids = func.call_.byArgs[data];
    require(ids.length > 0, NoCalls(bytes4(data[0:4])));

    return logs[ids[ids.length - 1 - offset]];
  }
}
