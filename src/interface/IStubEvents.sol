// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStubEvents {
  event Donation(address indexed from, uint256 amount);

  event ManagerUpdated(address indexed oldManager, address indexed newManager);
  event InspectorUpdated(address indexed oldInspector, address indexed newInspector);
  event ManagerImplUpdated(address indexed oldManagerImpl, address indexed newManagerImpl);
  event ExecutorImplUpdated(address indexed oldExecutorImpl, address indexed newExecutorImpl);
  event InspectorImplUpdated(address indexed oldInspectorImpl, address indexed newInspectorImpl);
}
