// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { console } from '@std/console.sol';

import { StubStorage } from './shared/StubStorage.sol';
import { StubManager } from './impl/StubManager.sol';
import { StubInspector } from './impl/StubInspector.sol';
import { StubExecutor } from './impl/StubExecutor.sol';
import { IStubEvents } from './interface/IStubEvents.sol';
import { IStubErrors } from './interface/IStubErrors.sol';
import { Versioned } from './lib/Versioned.sol';

import { Address } from '@oz/utils/Address.sol';

contract Stub is IStubEvents, StubStorage, Versioned {
  /// @dev keccak256(abi.encodeWithSelector(IStubErrors.NotImplemented.selector))
  bytes32 private constant ERR_NOT_IMPLEMENTED = 0xdb12950338915ad5275770347f72282296a9ecc3bed09f9d1d23051c469e3fad;

  constructor(string memory _name) {
    StorageV1 storage $ = _getStorageV1();

    $.name = _name;
    $.manager = msg.sender;
    $.inspector = msg.sender;
    $.managerImpl = address(new StubManager());
    $.executorImpl = address(new StubExecutor());
    $.inspectorImpl = address(new StubInspector());
  }

  receive() external payable {
    emit Donation(msg.sender, msg.value);
  }

  fallback() external payable {
    StorageV1 storage $ = _getStorageV1();

    bool handled = false;
    bytes memory ret;

    if (!handled && msg.sender == $.manager) {
      (handled, ret) = _handle($.managerImpl, msg.data);
    }

    if (!handled && msg.sender == $.inspector) {
      (handled, ret) = _handle($.inspectorImpl, msg.data);
    }

    // fallback to executor
    if (!handled) {
      // route to executor
      ret = Address.functionDelegateCall($.executorImpl, msg.data);
    }

    assembly {
      return(add(ret, 32), mload(ret))
    }
  }

  function _handle(address impl, bytes memory data) private returns (bool handled, bytes memory ret) {
    (handled, ret) = impl.delegatecall(data);
    if (!handled && keccak256(ret) != ERR_NOT_IMPLEMENTED) {
      assembly {
        revert(add(ret, 32), mload(ret))
      }
    }
  }
}
