// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IStubViewer } from './IStubViewer.sol';

interface IStubManager is IStubViewer {
  function updateManager(address newManager) external;
  function updateInspector(address newInspector) external;
  function updateManagerImpl(address newManagerImpl) external;
  function updateExecutorImpl(address newExecutorImpl) external;
  function updateInspectorImpl(address newInspectorImpl) external;

  function regF(bytes4 sig, bool isCall, string memory name) external;

  function setRet(bytes calldata data, bool revert_, bool default_, bytes calldata returnData) external;
  function setOk(bytes4 sig, bytes calldata returnData) external;
  function setOk(bytes calldata data, bytes calldata returnData) external;
  function setFail(bytes4 sig, bytes calldata revertData) external;
  function setFail(bytes calldata data, bytes calldata revertData) external;
}
