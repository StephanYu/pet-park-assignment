//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PetPark {
    enum AnimalType {
        Fish,
        Cat,
        Dog,
        Rabbit,
        Parrot
    }

    struct Animal {
        uint age;
        string gender;
        AnimalType animalType;
    }

    mapping(address => Animal) public borrowedAnimals;
    address public owner;

    event Added(AnimalType animalType, uint count);
    event Borrowed(AnimalType animalType);
    event Returned(AnimalType animalType);

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can perform this action"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function add(AnimalType _animalType, uint _count) external onlyOwner {
        emit Added(_animalType, _count);
    }

    function borrow(
        uint _age,
        string memory _gender,
        AnimalType _animalType
    ) external {
        require(
            borrowedAnimals[msg.sender].animalType == AnimalType(0),
            "You have already borrowed an animal"
        );
        require(
            (_gender == "Male" &&
                (_animalType == AnimalType.Dog || _animalType.Fish)) ||
                (_gender == "Female" &&
                    (_animalType != AnimalType.Cat || _age >= 40)),
            "Invalid combination of gender and animal type"
        );

        borrowedAnimals[msg.sender] = Animal(_age, _gender, _animalType);
        emit Borrowed(_animalType);
    }

    function giveBackAnimal() external {
        require(
            borrowedAnimals[msg.sender].animalType != AnimalType(0),
            "You haven't borrowed an animal"
        );

        AnimalType animalType = borrowedAnimals[msg.sender].animalType;
        delete borrowedAnimals[msg.sender];

        emit Returned(animalType);
    }
}
