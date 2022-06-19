
# Vite Tools
<!-- badges: start -->
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Twitter Follow](https://img.shields.io/twitter/follow/jaumebosch.svg?style=social)](https://twitter.com/jaumebosch)
<!-- badges: end -->
Simple shell scripts to deploy a [Vite](https://www.vite.org/) Node Server

## Introduction
[Vite](https://vite.org) has built a Directed Acyclic Graph (DAG) based smart-contract platform, with a Snapshot Chain structure to facilitate zero-fee transactions and optimize transaction speed, reliability, and security. The Snapshot Chain of Vite utilizes Hierarchical Delegated Proof of Stake (“HDPoS”) to achieve network consensus, while supernodes take only staking rewards and no transaction fees. Vite virtual machine maintains compatibility with EVM, and utilizes asynchronous smart contract language, Solidity++.

## Installation
Just install git with `apt install git` and execute `git clone https://github.com/jaumebosch/vite-tools.git`. Then `cd vite-tools` and execute `./setup.sh

## About
The script will download and install latest Vite Node stable release, also will modify some files for an optimal server performance. It also add a couple of checks to your .bashrc to verify if the server has the Vite service running and if it is the latest stable release.

## Notice
ledger_download.sh is still being developed, need some extra space for the ledger backup

## Tips & Donations
vite_47a4e7f81d9979a7537235e648319954d69847f3745aeab87e
![Vite QR](qr_vite.png)
