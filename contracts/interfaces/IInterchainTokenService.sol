// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IAxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarExecutable.sol';

import { ITokenManagerDeployer } from '../interfaces/ITokenManagerDeployer.sol';

interface IInterchainTokenService is ITokenManagerDeployer, IAxelarExecutable {
    error TokenServiceZeroAddress();
    error LengthMismatch();
    error NotRemoteService();

    event Sending(bytes32 tokenId, string destinationChain, bytes destinationAddress, uint256 indexed amount, bytes32 sendHahs);
    event SendingWithData(
        bytes32 tokenId,
        string destinationChain,
        bytes destinationAddress,
        uint256 indexed amount,
        address indexed sourceAddress,
        bytes data,
        bytes32 sendHash
    );
    event Receiving(
        bytes32 indexed tokenId,
        string sourceChain,
        address indexed destinationAddress,
        uint256 indexed amount,
        bytes32 sendHash
    );
    event ReceivingWithData(
        bytes32 indexed tokenId,
        string sourceChain,
        address indexed destinationAddress,
        uint256 indexed amount,
        bytes sourceAddress,
        bytes data,
        bool success,
        bytes32 sendHash
    );
    event TokenManagerDeployed(
        bytes32 indexed tokenId,
        address indexed tokenManagerAddress,
        address indexed admin,
        bytes32 salt,
        bytes params
    );
    event RemoteTokenRegisterInitialized(bytes32 indexed tokenId, string destinationChain, uint256 gasValue);

    function getValidTokenManagerAddress(bytes32 tokenId) external view returns (address tokenAddress);

    function getCanonicalTokenId(address tokenAddress) external view returns (bytes32 tokenId);

    function getCustomTokenId(address admin, bytes32 salt) external view returns (bytes32 tokenId);

    function registerCanonicalToken(address tokenAddress) external returns (bytes32 tokenId);

    function registerCanonicalTokenAndDeployRemoteTokens(
        address tokenAddress,
        string[] calldata destinationChains,
        uint256[] calldata gasValues
    ) external payable returns (bytes32 tokenId);

    function deployRemoteCanonicalTokens(
        bytes32 tokenId,
        string[] calldata destinationChains,
        uint256[] calldata gasValues
    ) external payable;

    function deployInterchainToken(
        string calldata tokenName,
        string calldata tokenSymbol,
        uint8 decimals,
        address owner,
        bytes32 salt,
        string[] calldata destinationChains,
        uint256[] calldata gasValues
    ) external payable;

    function deployCustomTokenManager(bytes32 salt, TokenManagerType tokenManagerType, bytes calldata params) external;

    function deployRemoteCustomTokenManagers(
        bytes32 salt,
        string[] calldata destinationChains,
        TokenManagerType[] calldata tokenManagerTypes,
        bytes[] calldata params,
        uint256[] calldata gasValues
    ) external payable;

    function deployCustomTokenManagerAndDeployRemote(
        bytes32 salt,
        TokenManagerType tokenManagerType,
        bytes calldata params,
        string[] calldata destinationChains,
        TokenManagerType[] calldata tokenManagerTypes,
        bytes[] calldata remoteParams,
        uint256[] calldata gasValues
    ) external;

    function getImplementation(TokenManagerType tokenManagerType) external view returns (address tokenManagerAddress);
}
