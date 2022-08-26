# Run an QRNG Api3 node for local testing

## Installation

`forge install api3doa/airnode forge-std openzeppelin/openzeppelin-contracts`

``

## Running

Docker: https://github.com/api3dao/airnode/tree/v0.7/packages/airnode-node/docker

`docker pull api3/airnode-client`

We want to match the version we're setting up in our `config.json`, it `0.7.5`, therefore the the image we're using is: `api3/airnode-client:0.7.5`.

`docker run --rm -v $(pwd)/airnode/config:/app/config --publish 3000:3000 --name airnode api3/airnode-client:0.7.5`
