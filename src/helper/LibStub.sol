// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { IStubManager } from '../interface/IStubManager.sol';
import { IStubInspector } from '../interface/IStubInspector.sol';

library LibStub {
  function manager(address stub) internal pure returns (IStubManager) {
    return IStubManager(stub);
  }

  function inspector(address stub) internal pure returns (IStubInspector) {
    return IStubInspector(stub);
  }
}
