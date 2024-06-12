ifneq (,$(wildcard ./.env))
    include .env
    export
endif

DEPLOY_CMD = forge script script/Deploy.s.sol:$(CONTRACT)Script --rpc-url $(RPC_URL) --broadcast

.PHONY: clean test
all: clean deploy-all-contract verify-all-contract
test:
	forge test --gas-report
clean:
	forge clean && rm -rf cache
ilo-manager:
	$(eval CONTRACT=ILOManager)
ilo-pool:
	$(eval CONTRACT=ILOPool)
all-contract:
	$(eval CONTRACT=AllContract)
deploy-all-contract:
deploy-ilo-manager:
deploy-ilo-pool:
deploy-ilo-manager-legacy:
deploy-ilo-pool-legacy:
deploy-ilo-manager-with-gas-price:
deploy-ilo-pool-with-gas-price:
deploy-%: % 
	$(DEPLOY_CMD)
deploy-%-legacy: % 
	$(DEPLOY_CMD) --legacy
deploy-%-with-gas-price: %
	$(DEPLOY_CMD) --legacy --gas-price $(GAS_PRICE)

verify-all-contract:
verify-ilo-manager:
verify-ilo-pool:
verify-%: %
	forge script script/Verify.s.sol:Verify$(CONTRACT)Script | awk 'END{print}' | bash
init-ilo-manager:
init-ilo-pool:
init-ilo-manager:
	forge script script/Init.s.sol:ILOManagerInitializeScript --rpc-url $(RPC_URL) --broadcast
