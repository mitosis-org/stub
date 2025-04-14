// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { console } from '@std/console.sol';

import { IStubTypes } from '../interface/IStubTypes.sol';
import { LibString } from '@solady/utils/LibString.sol';

library Printer {
  using LibString for *;

  function print(IStubTypes.Func storage v, string memory label, uint256 indent) internal view {
    string memory sig = abi.encodePacked(v.sig).toHexString();
    bool useNameLabel = label.cmp('') == 0 && v.name.cmp('') != 0;
    bool useSigLabel = label.cmp('') == 0 && v.name.cmp('') == 0;
    label = string.concat(' '.repeat(indent), useNameLabel ? v.name : useSigLabel ? sig : label);

    // main
    if (!useSigLabel) console.log(label, '.sig:', sig);
    if (!useNameLabel) console.log(label, '.name:', v.name);
    console.log(label, '.isCall:', str(v.isCall));

    // call
    console.log(label, '.call:');
    print(v.call_, '', indent + 2);

    // match
    console.log(label, '.match:');
    print(v.match_, '', indent + 2);
  }

  function print(IStubTypes.Call storage v, string memory label, uint256 indent) internal view {
    label = string.concat(' '.repeat(indent), label);

    IStubTypes.Log[] storage logs = v.logs;
    uint256 len = logs.length;
    for (uint256 i = 0; i < len; i++) {
      print(logs[i], labelArrElem(label, 'logs', i), indent + 2);
    }
  }

  function print(IStubTypes.Match storage v, string memory label, uint256 indent) internal view {
    label = string.concat(' '.repeat(indent), label);

    print(v.default_, string.concat(label, '.default_'), indent + 2);

    bytes[] storage args = v.args;
    uint256 len = args.length;
    for (uint256 i = 0; i < len; i++) {
      print(v.byArgs[args[i]], labelArrElem(label, 'byArgs', i), indent + 2);
    }
  }

  function print(IStubTypes.Ret memory v, string memory label, uint256 indent) internal pure {
    label = string.concat(' '.repeat(indent), label);

    console.log(label, '.registered:', str(v.registered));
    console.log(label, '.revert_:', str(v.revert_));
    console.log(label, '.data:', v.data.toHexString());
  }

  function print(IStubTypes.Log memory v, string memory label, uint256 indent) internal pure {
    label = string.concat(' '.repeat(indent), label);

    console.log(label, '.sig:', abi.encodePacked(v.sig).toHexString());
    console.log(label, '.args:', v.args.toHexString());
  }

  function str(bool v) private pure returns (string memory) {
    return v ? 'true' : 'false';
  }

  function labelArrElem(string memory label, string memory field, uint256 i) private pure returns (string memory) {
    return string.concat(label, '.', field, '[', i.toString(), ']');
  }
}
