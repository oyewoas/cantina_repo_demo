// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    address public owner;
    uint256 public totalVotes;
    uint256 public winningProposalId;

    struct Proposal {
        string name;
        uint256 voteCount;
    }

    Proposal[] public proposals;

    mapping(address => bool) public hasVoted;

    event ProposalAdded(uint256 proposalId, string name);
    event Voted(address voter, uint256 proposalId);
    event WinnerDeclared(uint256 proposalId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(string[] memory proposalNames) {
        owner = msg.sender;
        totalVotes = 0;

        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({ name: proposalNames[i], voteCount: 0 }));
            emit ProposalAdded(i, proposalNames[i]);
        }
    }

    function vote(uint256 proposalId) public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(proposalId < proposals.length, "Invalid proposal ID");

        proposals[proposalId].voteCount++;
        totalVotes++;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, proposalId);
    }

    function declareWinner() public onlyOwner {
        uint256 maxVotes = 0;
        uint256 winningId = 0;

        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningId = i;
            }
        }

        winningProposalId = winningId;
        emit WinnerDeclared(winningId);
    }
}
