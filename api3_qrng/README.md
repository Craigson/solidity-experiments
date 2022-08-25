# Run an QRNG Api3 node for local testing

## Installation

`forge install api3doa/airnode forge-std openzeppelin/openzeppelin-contracts`

``

## Running

Docker: https://github.com/api3dao/airnode/tree/v0.7/packages/airnode-node/docker

`docker pull api3/airnode-client`

`docker run --rm -v $(pwd)/airnode/config:/app/config --publish 3000:3000 --name airnode api3/airnode-client`
