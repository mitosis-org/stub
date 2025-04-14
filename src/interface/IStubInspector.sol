// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IStubTypes } from './IStubTypes.sol';
import { IStubViewer } from './IStubViewer.sol';

interface IStubInspector is IStubViewer {
  // expect latest call
  function expectOk(bytes4 sig) external view returns (IStubTypes.Ret memory);
  function expectOk(bytes4 sig, uint256 value) external view returns (IStubTypes.Ret memory);
  function expectOk(bytes calldata data) external view returns (IStubTypes.Ret memory);
  function expectOk(bytes calldata data, uint256 value) external view returns (IStubTypes.Ret memory);

  // expect call at (latest - offset)
  function expectOk(uint256 offset, bytes4 sig) external view returns (IStubTypes.Ret memory);
  function expectOk(uint256 offset, bytes4 sig, uint256 value) external view returns (IStubTypes.Ret memory);
  function expectOk(uint256 offset, bytes calldata data) external view returns (IStubTypes.Ret memory);
  function expectOk(uint256 offset, bytes calldata data, uint256 value) external view returns (IStubTypes.Ret memory);

  // expect latest call
  function expectFail(bytes4 sig) external view returns (IStubTypes.Ret memory);
  function expectFail(bytes4 sig, uint256 value) external view returns (IStubTypes.Ret memory);
  function expectFail(bytes calldata data) external view returns (IStubTypes.Ret memory);
  function expectFail(bytes calldata data, uint256 value) external view returns (IStubTypes.Ret memory);

  // expect call at (latest - offset)
  function expectFail(uint256 offset, bytes4 sig) external view returns (IStubTypes.Ret memory);
  function expectFail(uint256 offset, bytes4 sig, uint256 value) external view returns (IStubTypes.Ret memory);
  function expectFail(uint256 offset, bytes calldata data) external view returns (IStubTypes.Ret memory);
  function expectFail(uint256 offset, bytes calldata data, uint256 value) external view returns (IStubTypes.Ret memory);
}
