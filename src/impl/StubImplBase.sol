// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IStubErrors } from '../interface/IStubErrors.sol';

abstract contract StubImplBase is IStubErrors {
  address public immutable self;

  receive() external payable virtual { }

  fallback() external payable virtual onlyProxy {
    revert NotImplemented();
  }

  constructor() {
    self = address(this);
  }

  modifier onlyProxy() {
    require(address(this) != self, OnlyProxy(self, address(this)));
    _;
  }
}
