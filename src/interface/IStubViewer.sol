// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IStubTypes } from './IStubTypes.sol';

interface IStubViewer {
  function name() external view returns (string memory);
  function getManager() external view returns (address);
  function getInspector() external view returns (address);
  function getManagerImpl() external view returns (address);
  function getExecutorImpl() external view returns (address);
  function getInspectorImpl() external view returns (address);

  function getCall(bytes4 sig) external view returns (IStubTypes.Log memory);
  function getCall(uint256 offset, bytes4 sig) external view returns (IStubTypes.Log memory);

  function getCall(bytes calldata data) external view returns (IStubTypes.Log memory);
  function getCall(uint256 offset, bytes calldata data) external view returns (IStubTypes.Log memory);

  function getCallCount(bytes4 sig) external view returns (uint256);
  function getCallCount(bytes calldata data) external view returns (uint256);
}
