// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStubTypes {
  struct Ret {
    bool registered;
    bool revert_;
    bytes data;
  }

  struct Log {
    bytes4 sig;
    bytes args;
    uint256 value;
    Ret ret;
  }

  struct Match {
    Ret default_;
    bytes[] args;
    mapping(bytes => Ret) byArgs;
  }

  struct Call {
    Log[] logs;
    mapping(bytes => uint256[]) byArgs;
  }

  struct Func {
    bytes4 sig;
    string name;
    bool isCall;
    Call call_;
    Match match_;
  }
}
