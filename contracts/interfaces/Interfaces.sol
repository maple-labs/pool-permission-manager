// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.7;

interface IGlobalsLike { 

    function governor() external view returns (address);

    function isInstanceOf(bytes32 key, address account) external view returns (bool);

    function poolDelegates(address poolDelegate) external view returns (address ownedPoolManager, bool isPoolDelegate);

}