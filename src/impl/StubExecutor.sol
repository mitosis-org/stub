// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { StubStorage } from '../shared/StubStorage.sol';
import { StubImplBase } from './StubImplBase.sol';

contract StubExecutor is StubImplBase, StubStorage {
  fallback() external payable override onlyProxy {
    StorageV1 storage $ = _getStorageV1();

    Func storage func = $.funcs[msg.sig];
    (Ret memory ret, bool isDefault) = _getRet(func, msg.data[4:]);

    _recordCall(func, msg.data[4:], msg.value, ret, isDefault);
    _execRet(ret);
  }

  /// @notice Gets the return value for a function call
  /// @param func The function to get the return value for
  /// @param args The arguments to get the return value for
  /// @return ret The return value for the function call
  /// @return isDefault Whether the return value is the default value
  function _getRet(Func storage func, bytes memory args) internal view returns (Ret memory, bool) {
    if (func.match_.byArgs[args].registered) return (func.match_.byArgs[args], false);
    else if (func.match_.default_.registered) return (func.match_.default_, true);
    else revert NoRetRegistered(func.sig, args);
  }

  /// @notice Executes a return value
  /// @param ret The return value to execute
  function _execRet(Ret memory ret) internal pure {
    bytes memory data = ret.data;
    if (ret.revert_) {
      assembly {
        revert(add(data, 32), mload(data))
      }
    } else {
      assembly {
        return(add(data, 32), mload(data))
      }
    }
  }

  /// @notice Records a function call
  /// @dev Only records calls for functions that are not static - state changes are not supported on static calls
  /// @param func The function to record the call for
  /// @param args The arguments to record the call for
  /// @param value The value to record the call for
  /// @param ret The return value to record the call for
  /// @param isDefault Whether the return value is the default value
  function _recordCall(Func storage func, bytes calldata args, uint256 value, Ret memory ret, bool isDefault) internal {
    if (func.isCall) {
      Call storage call_ = func.call_;
      call_.logs.push(Log({ sig: func.sig, args: args, value: value, ret: ret }));
      if (!isDefault) call_.byArgs[args].push(call_.logs.length - 1);
    }
  }
}
