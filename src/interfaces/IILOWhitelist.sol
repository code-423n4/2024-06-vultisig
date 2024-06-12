// SPDX-License-Identifier: BUSL-1.1 

pragma solidity =0.7.6;

interface IILOWhitelist {

    event SetWhitelist(address indexed user, bool isWhitelist);
    event SetOpenToAll(bool openToAll);

    function setOpenToAll(bool openToAll) external;
    function isOpenToAll() external returns(bool);
    function isWhitelisted(address user) external returns (bool);
    function batchWhitelist(address[] calldata users) external;
    function batchRemoveWhitelist(address[] calldata users) external;

    modifier onlyProjectAdmin virtual;

}