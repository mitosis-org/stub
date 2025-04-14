// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC7201Utils } from '../lib/ERC7201Utils.sol';

import { IStubTypes } from '../interface/IStubTypes.sol';

abstract contract StubStorage is IStubTypes {
  using ERC7201Utils for string;

  struct StorageV1 {
    string name;
    address manager;
    address inspector;
    address managerImpl;
    address executorImpl;
    address inspectorImpl;
    mapping(bytes4 => Func) funcs;
  }

  string private constant _NAMESPACE = 'mitosis.storage.Stub.v1';
  bytes32 private immutable _slot = _NAMESPACE.storageSlot();

  function _getStorageV1() internal view returns (StorageV1 storage $) {
    bytes32 slot = _slot;
    assembly {
      $.slot := slot
    }
  }
}
