pragma solidity ^0.8.0;

import { LibAppStorage } from "../libraries/LibAppStorage.sol";
import { IERC20 } from "../interfaces/IERC20.sol";


contract StakingFacet {
    LibAppStorage.Staking st;
    LibAppStorage.ERC20 rewardToken;

    // st.stakeToken = stakeToken;
    // st.rewardToken = rewardToken;
    // st.totalSupply = totalSupply;
    // st.duration = duration;
    // st.balanceOf = balanceOf;
    // st.stakeTime = stakeTime;
    // st.rewards = rewards;


    event StakingSuccessful(address indexed user, uint amount);

    constructor(address _stakeToken, address _rewardToken) {
        st.stakeToken = _stakeToken;
        st.rewardToken = _rewardToken;
    }

    function stake(uint _amount) external {
        // st.stakeToken = stakeToken;
        // st.totalSupply = totalSupply;
        // st.stakeTime = stakeTime;

        require(msg.sender != address(0), "Address Zero");
        require (_amount >= 0, "Invalid amount");
        require(IERC20(st.stakeToken).balanceOf(msg.sender) >= _amount, "insuffiecient balance");

        IERC20(st.stakeToken).transferFrom(msg.sender, address(this), _amount);

        st.balanceOf[msg.sender] += _amount;
        st.totalSupply += _amount;
        st.stakeTime[msg.sender] = block.timestamp;

        emit StakingSuccessful(msg.sender, _amount);
    }

    function calculateReward(uint _amount) private view returns (uint) {
        uint time = block.timestamp - st.stakeTime[msg.sender];
        uint annualReward = (_amount * 12) / 1000; // 12% APY
        uint reward = (time * annualReward) / 365 days;
        return reward;
    }

    function claimReward() external {
        uint totalRewards = calculateReward(st.balanceOf[msg.sender]);

        IERC20(st.rewardToken).transfer(msg.sender, totalRewards);
        st.rewards[msg.sender] += totalRewards;
    }

    function withdraw(uint _amount) external {
        require(st.balanceOf[msg.sender] >= _amount, "unsufficient funds");

        st.balanceOf[msg.sender] -= _amount;
        st.totalSupply -= _amount;
        IERC20(st.stakeToken).transfer(msg.sender, _amount);
    }

    function unstake() external {
        uint totalReward = st.rewards[msg.sender];
        uint totalStake = st.balanceOf[msg.sender];

        st.rewards[msg.sender] = 0;
        st.balanceOf[msg.sender] = 0;

        IERC20(st.stakeToken).transfer(msg.sender, totalStake);
        IERC20(st.rewardToken).transfer(msg.sender, totalReward);
    }
}