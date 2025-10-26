// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {FixedPriceOracle} from "../src/Oracle/FixedPriceOracle.sol";
import {AiAgent} from "../src/core/DeployPersonalizedAI.sol";
import {EntryPoint} from "../src/core/EntryPoint.sol";
import {HealthDataNFT} from "../src/core/HealthDataNFT.sol";
import {HospitalRequestContract} from "../src/core/HospitalRequestContract.sol";
import {HospitalRequestFactoryContract} from "../src/core/HospitalRequestFactory.sol";
import {HRC} from "../src/core/HRS.sol";
import {MarketPlace} from "../src/core/MarketPlace.sol";
import {ProfileImageNfts} from "../src/core/NftContract.sol";
import {Process} from "../src/core/Process.sol";
import {ProcessFactoryContract} from "../src/core/ProcessFactory.sol";
import {VerificationOfParties} from "../src/core/VerificationOfParties.sol";
import {AiAgentFactory} from "../src/core/AgentFactory.sol";
import "../src/core/reward.sol";
import "forge-std/console.sol";

contract DeployScript is Script {
    AiAgentFactory agentFactory;
    FixedPriceOracle oracle;
    AiAgent ai;
    EntryPoint entry;
    HealthDataNFT hnft;
    HospitalRequestContract requestContract;
    HospitalRequestFactoryContract requestFactory;
    HRC hrc;
    MarketPlace market;
    ProfileImageNfts pnft;
    Process process;
    ProcessFactoryContract processFactory;
    VerificationOfParties verification;

    RewardContract reward;
    address public hospitalAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public maxdonors = 50;
    address tokenAddress = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    uint256 stepsToComplete = 9;
    uint256 _price = 6;
    address nftReceiptent = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

    function run() public {
        vm.createSelectFork(vm.rpcUrl("hedera_testnet"));
        vm.startBroadcast();
        // using hedera testnet rpc
        oracle = new FixedPriceOracle(_price);

        agentFactory = new AiAgentFactory();

        // Deploy core dependencies in correct order
        process = new Process();
        hnft = new HealthDataNFT(address(process));

        requestContract = new HospitalRequestContract();
        requestFactory = new HospitalRequestFactoryContract(
            address(requestContract),
            address(hospitalAddress),
            maxdonors
        );
        entry = new EntryPoint(address(requestFactory));

        hrc = new HRC(address(entry), address(requestContract));

        market = new MarketPlace(
            address(hnft),
            address(tokenAddress),
            address(oracle)
        );

        pnft = new ProfileImageNfts();

        verification = new VerificationOfParties();

        processFactory = new ProcessFactoryContract(
            address(process),
            address(nftReceiptent),
            address(hrc),
            stepsToComplete
        );

        ai = new AiAgent(
            address(hrc),
            address(verification),
            address(agentFactory)
        );

        reward = new RewardContract(address(hrc));
        vm.stopBroadcast();

        console.log("NEXT_PUBLIC_FIXED_ORACLE_PRICE_ADDRESS=", address(oracle));
        console.log(
            "NEXT_PUBLIC_AIAGENT_FACTORY_ADDRESS=",
            address(agentFactory)
        );
        console.log("NEXT_PUBLIC_ENTRY_POINT_ADDRESS=", address(entry));
        console.log("NEXT_PUBLIC_HEALTH_DATA_NFT_ADDRESS=", address(hnft));
        console.log(
            "NEXT_PUBLIC_HOSPITAL_REQUEST_CONTRACT_ADDRESS=",
            address(requestContract)
        );
        console.log(
            "NEXT_PUBLIC_HOSPITAL_REQUEST_FACTORY_ADDRESS=",
            address(requestFactory)
        );
        console.log("NEXT_PUBLIC_HRS_ADDRESS=", address(hrc));
        console.log("NEXT_PUBLIC_MARKETPLACE_ADDRESS=", address(market));
        console.log("NEXT_PUBLIC_PROFILE_IMAGE_NFT_ADDRESS=", address(pnft));
        console.log("NEXT_PUBLIC_PROCESS_ADDRESS=", address(process));
        console.log("NEXT_PUBLIC_AI=", address(ai));
        console.log(
            "NEXT_PUBLIC_PROCESS_FACTORY_ADDRESS=",
            address(processFactory)
        );
        console.log("NEXT_PUBLIC_VERIFICATION_ADDRESS=", address(verification));
        console.log("NEXT_PUBLIC_REWARD_ADDRESS=", address(reward));
    }
}

contract DeployBatch1 is Script {
    // Shared config
    address public hospitalAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public maxdonors = 50;
    address tokenAddress = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    uint256 stepsToComplete = 9;
    uint256 _price = 6;
    address nftReceiptent = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

    function run() public {
        vm.createSelectFork(vm.rpcUrl("hedera_testnet"));
        vm.startBroadcast();
        FixedPriceOracle oracle = new FixedPriceOracle(_price);
        AiAgentFactory agentFactory = new AiAgentFactory();
        Process process = new Process();
        HealthDataNFT hnft = new HealthDataNFT(address(process));
        vm.stopBroadcast();

        console.log("NEXT_PUBLIC_FIXED_ORACLE_PRICE_ADDRESS=", address(oracle));
        console.log("NEXT_PUBLIC_AIAGENT_FACTORY_ADDRESS=", address(agentFactory));
        console.log("NEXT_PUBLIC_PROCESS_ADDRESS=", address(process));
        console.log("NEXT_PUBLIC_HEALTH_DATA_NFT_ADDRESS=", address(hnft));
    }
}

contract DeployBatch2 is Script {
    // Shared config
    address public hospitalAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public maxdonors = 50;

    function run() public {
        vm.createSelectFork(vm.rpcUrl("hedera_testnet"));
        vm.startBroadcast();
        HospitalRequestContract requestContract = new HospitalRequestContract();
        HospitalRequestFactoryContract requestFactory = new HospitalRequestFactoryContract(
            address(requestContract),
            address(hospitalAddress),
            maxdonors
        );
        EntryPoint entry = new EntryPoint(address(requestFactory));
        vm.stopBroadcast();

        console.log("NEXT_PUBLIC_HOSPITAL_REQUEST_CONTRACT_ADDRESS=", address(requestContract));
        console.log("NEXT_PUBLIC_HOSPITAL_REQUEST_FACTORY_ADDRESS=", address(requestFactory));
        console.log("NEXT_PUBLIC_ENTRY_POINT_ADDRESS=", address(entry));
    }
}

contract DeployBatch3 is Script {
    function run() public {
        // Requires env: ENTRY_POINT_ADDRESS, HOSPITAL_REQUEST_CONTRACT_ADDRESS
        address entryAddr = vm.envAddress("ENTRY_POINT_ADDRESS");
        address reqContractAddr = vm.envAddress("HOSPITAL_REQUEST_CONTRACT_ADDRESS");

        vm.createSelectFork(vm.rpcUrl("hedera_testnet"));
        vm.startBroadcast();
        HRC hrc = new HRC(entryAddr, reqContractAddr);
        VerificationOfParties verification = new VerificationOfParties();
        ProfileImageNfts pnft = new ProfileImageNfts();
        vm.stopBroadcast();

        console.log("NEXT_PUBLIC_HRS_ADDRESS=", address(hrc));
        console.log("NEXT_PUBLIC_VERIFICATION_ADDRESS=", address(verification));
        console.log("NEXT_PUBLIC_PROFILE_IMAGE_NFT_ADDRESS=", address(pnft));
    }
}

contract DeployBatch4 is Script {
    // Shared config
    address tokenAddress = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    uint256 stepsToComplete = 9;
    address nftReceiptent = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

    function run() public {
        // Requires env: PROCESS_ADDRESS, HRS_ADDRESS, HEALTH_DATA_NFT_ADDRESS, FIXED_ORACLE_PRICE_ADDRESS, AIAGENT_FACTORY_ADDRESS, VERIFICATION_ADDRESS
        address processAddr = vm.envAddress("PROCESS_ADDRESS");
        address hrcAddr = vm.envAddress("HRS_ADDRESS");
        address hnftAddr = vm.envAddress("HEALTH_DATA_NFT_ADDRESS");
        address oracleAddr = vm.envAddress("FIXED_ORACLE_PRICE_ADDRESS");
        address agentFactoryAddr = vm.envAddress("AIAGENT_FACTORY_ADDRESS");
        address verificationAddr = vm.envAddress("VERIFICATION_ADDRESS");

        vm.createSelectFork(vm.rpcUrl("hedera_testnet"));
        vm.startBroadcast();
        ProcessFactoryContract processFactory = new ProcessFactoryContract(
            processAddr,
            nftReceiptent,
            hrcAddr,
            stepsToComplete
        );
        MarketPlace market = new MarketPlace(
            hnftAddr,
            tokenAddress,
            oracleAddr
        );
        AiAgent ai = new AiAgent(
            hrcAddr,
            verificationAddr,
            agentFactoryAddr
        );
        RewardContract reward = new RewardContract(hrcAddr);
        vm.stopBroadcast();

        console.log("NEXT_PUBLIC_PROCESS_FACTORY_ADDRESS=", address(processFactory));
        console.log("NEXT_PUBLIC_MARKETPLACE_ADDRESS=", address(market));
        console.log("NEXT_PUBLIC_AI=", address(ai));
        console.log("NEXT_PUBLIC_REWARD_ADDRESS=", address(reward));
    }
}

