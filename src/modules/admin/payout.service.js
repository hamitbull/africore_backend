// Payouts are deliberately disabled until verified beneficiary bank details,
// idempotent provider transfers, and a wallet-reservation ledger are implemented.
// The previous implementation could pay out without debiting/reserving the wallet.

const createPayout = async () => {
    throw new Error(
        "Payout requests are temporarily disabled while secure bank verification and ledger reservation are completed."
    );
};

const processPayout = async () => {
    throw new Error(
        "Payout processing is disabled until a reconciled payout ledger is available."
    );
};

module.exports = { createPayout, processPayout };
