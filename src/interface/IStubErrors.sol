// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IStubTypes } from './IStubTypes.sol';

interface IStubErrors {
  error OnlyProxy(address expected, address actual);
  error NoRetRegistered(bytes4 sig, bytes args);

  error NotMatchedBySig(bytes4 sig, bool revert_, uint256 value, IStubTypes.Log actual);
  error NotMatchedByArgs(bytes args, bool revert_, uint256 value, IStubTypes.Log actual);

  error NotACall(bytes4 sig, string name);
  error NoCalls(bytes4 sig);

  error NotImplemented();
  error Unauthorized();
  error ZeroAddress();
  error ZeroAmount();
  error NoCode();
}
