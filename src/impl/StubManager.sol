// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { StubViewer } from './StubViewer.sol';

import { IStubManager } from '../interface/IStubManager.sol';
import { IStubErrors } from '../interface/IStubErrors.sol';
import { IStubEvents } from '../interface/IStubEvents.sol';

contract StubManager is IStubManager, IStubEvents, IStubErrors, StubViewer {
  // ====================================== CONTRACT SETUP ====================================== //

  function updateManager(address newManager) external onlyProxy {
    require(newManager != address(0), ZeroAddress());

    StorageV1 storage $ = _getStorageV1();

    address oldManager = $.manager;
    require(msg.sender == oldManager, Unauthorized());
    $.manager = newManager;

    emit ManagerUpdated(oldManager, newManager);
  }

  function updateInspector(address newInspector) external onlyProxy {
    require(newInspector != address(0), ZeroAddress());

    StorageV1 storage $ = _getStorageV1();
    require(msg.sender == $.manager, Unauthorized());

    address oldInspector = $.inspector;
    $.inspector = newInspector;

    emit InspectorUpdated(oldInspector, newInspector);
  }

  function updateManagerImpl(address newManagerImpl) external onlyProxy {
    require(newManagerImpl != address(0), ZeroAddress());
    require(newManagerImpl.code.length > 0, NoCode());

    StorageV1 storage $ = _getStorageV1();
    require(msg.sender == $.manager, Unauthorized());

    address oldManagerImpl = $.managerImpl;
    $.managerImpl = newManagerImpl;

    emit ManagerImplUpdated(oldManagerImpl, newManagerImpl);
  }

  function updateExecutorImpl(address newExecutorImpl) external onlyProxy {
    require(newExecutorImpl != address(0), ZeroAddress());
    require(newExecutorImpl.code.length > 0, NoCode());

    StorageV1 storage $ = _getStorageV1();
    require(msg.sender == $.manager, Unauthorized());

    address oldExecutorImpl = $.executorImpl;
    $.executorImpl = newExecutorImpl;

    emit ExecutorImplUpdated(oldExecutorImpl, newExecutorImpl);
  }

  function updateInspectorImpl(address newInspectorImpl) external onlyProxy {
    require(newInspectorImpl != address(0), ZeroAddress());
    require(newInspectorImpl.code.length > 0, NoCode());

    StorageV1 storage $ = _getStorageV1();
    require(msg.sender == $.manager, Unauthorized());

    address oldInspectorImpl = $.inspectorImpl;
    $.inspectorImpl = newInspectorImpl;

    emit InspectorImplUpdated(oldInspectorImpl, newInspectorImpl);
  }

  // ====================================== FUNCTION LEVEL SETUP ====================================== //

  function regF(bytes4 sig, bool isCall, string memory name) external onlyProxy {
    Func storage func = _getStorageV1().funcs[sig];
    func.sig = sig;
    func.name = name;
    func.isCall = isCall;
  }

  // ====================================== CALL LEVEL SETUP ====================================== //

  function setOk(bytes4 sig, bytes calldata returnData) external onlyProxy {
    _setRet(sig, bytes(''), false, true, returnData);
  }

  function setOk(bytes calldata data, bytes calldata returnData) external onlyProxy {
    _setRet(bytes4(data[:4]), data[4:], false, false, returnData);
  }

  function setFail(bytes4 sig, bytes calldata revertData) external onlyProxy {
    _setRet(sig, bytes(''), true, true, revertData);
  }

  function setFail(bytes calldata data, bytes calldata revertData) external onlyProxy {
    _setRet(bytes4(data[:4]), data[4:], true, false, revertData);
  }

  function setRet(bytes calldata data, bool revert_, bool default_, bytes calldata returnData) external onlyProxy {
    _setRet(bytes4(data[:4]), data[4:], revert_, default_, returnData);
  }

  /// @notice Sets a return value for a function call
  /// @param sig The selector of the function call
  /// @param args The arguments of the function call
  /// @param revert_ Whether the function call should revert
  /// @param default_ Whether the function call should use the default return value
  /// @param returnData The return data to be used if the call does not revert
  function _setRet(bytes4 sig, bytes memory args, bool revert_, bool default_, bytes calldata returnData) internal {
    Func storage func = _getStorageV1().funcs[sig];
    Match storage match_ = func.match_;

    Ret memory ret = Ret({ registered: true, revert_: revert_, data: returnData });
    if (default_) {
      match_.default_ = ret;
    } else {
      if (!match_.byArgs[args].registered) match_.args.push(args);
      match_.byArgs[args] = ret;
    }
  }
}
