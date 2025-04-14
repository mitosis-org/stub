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
    label = cat(' '.repeat(indent), useNameLabel ? v.name : useSigLabel ? sig : label);

    // main
    if (!useSigLabel) console.log(cat(label, '.sig:'), sig);
    if (!useNameLabel) console.log(cat(label, '.name:'), v.name);
    console.log(cat(label, '.isCall:'), str(v.isCall));

    // call
    if (v.call_.logs.length > 0) {
      console.log(cat(label, '.call:'));
      print(v.call_, '', indent + 1);
    } else {
      console.log(cat(label, '.call:'), 'empty');
    }

    // match
    if (v.match_.default_.registered || v.match_.args.length > 0) {
      console.log(cat(label, '.match:'));
      print(v.match_, '', indent + 1);
    } else {
      console.log(cat(label, '.match:'), 'empty');
    }
  }

  function print(IStubTypes.Call storage v, string memory label, uint256 indent) internal view {
    label = cat(' '.repeat(indent), label);

    IStubTypes.Log[] storage logs = v.logs;
    uint256 len = logs.length;
    for (uint256 i = 0; i < len; i++) {
      print(logs[i], labelArrElem(label, 'logs', i), indent);
    }
  }

  function print(IStubTypes.Match storage v, string memory label, uint256 indent) internal view {
    label = cat(' '.repeat(indent), label);

    print(v.default_, cat(label, '.default_'), indent);

    bytes[] storage args = v.args;
    uint256 len = args.length;
    for (uint256 i = 0; i < len; i++) {
      print(v.byArgs[args[i]], labelArrElem(label, 'byArgs', i), indent);
    }
  }

  function print(IStubTypes.Ret memory v, string memory label, uint256 indent) internal pure {
    label = cat(' '.repeat(indent), label);

    console.log(cat(label, '.registered:'), str(v.registered));
    console.log(cat(label, '.revert_:'), str(v.revert_));
    console.log(cat(label, '.data:'), v.data.toHexString());
  }

  function print(IStubTypes.Log memory v, string memory label, uint256 indent) internal pure {
    label = cat(' '.repeat(indent), label);

    console.log(cat(label, '.sig:'), abi.encodePacked(v.sig).toHexString());
    console.log(cat(label, '.args:'), v.args.toHexString());
  }

  function str(bool v) private pure returns (string memory) {
    return v ? 'true' : 'false';
  }

  function cat(string memory a, string memory b) private pure returns (string memory) {
    return string.concat(a, b);
  }

  function labelArrElem(string memory label, string memory field, uint256 i) private pure returns (string memory) {
    return string.concat(label, '.', field, '[', i.toString(), ']');
  }
}
