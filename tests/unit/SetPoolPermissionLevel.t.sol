// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.7;

import { PoolPermissionManagerTestBase } from "./PoolPermissionManagerTestBase.t.sol";

contract SetPoolPermissionLevelTests is PoolPermissionManagerTestBase {

    function test_setPoolPermissionLevel_unauthorized() external {
        globals.__setPoolDelegate(poolManager, false);

        vm.expectRevert("PPM:NOT_PD");
        ppm.setPoolPermissionLevel(poolManager, 3);
    }

    function test_setPoolPermissionLevel_public() external {
        vm.prank(poolDelegate);
        ppm.setPoolPermissionLevel(poolManager, 3);

        vm.prank(poolDelegate);
        vm.expectRevert("PPM:SPPL:PUBLIC_POOL");
        ppm.setPoolPermissionLevel(poolManager, 0);
    }

    function test_setPoolPermissionLevel_invalid() external {
        vm.prank(poolDelegate);
        vm.expectRevert("PPM:SPPL:INVALID_LEVEL");
        ppm.setPoolPermissionLevel(poolManager, 4);
    }

    function test_setPoolPermissionLevel_success() external {
        assertEq(ppm.poolPermissions(poolManager), 0);

        vm.prank(poolDelegate);
        ppm.setPoolPermissionLevel(poolManager, 1);

        assertEq(ppm.poolPermissions(poolManager), 1);
    }

    function testFuzz_setPoolPermissionLevel(uint256 oldPermissionLevel, uint256 newPermissionLevel) external {
        oldPermissionLevel = bound(oldPermissionLevel, 0, 3);
        newPermissionLevel = bound(newPermissionLevel, 0, 3);

        vm.prank(poolDelegate);
        ppm.setPoolPermissionLevel(poolManager, oldPermissionLevel);

        if (oldPermissionLevel == 3) {
            vm.expectRevert("PPM:SPPL:PUBLIC_POOL");
        }

        vm.prank(poolDelegate);
        ppm.setPoolPermissionLevel(poolManager, newPermissionLevel);

        assertEq(ppm.poolPermissions(poolManager), oldPermissionLevel == 3 ? oldPermissionLevel : newPermissionLevel);
    }

}