/**
 * ============================================
 * 📱 AFRICORE SDK (Mini App Integration)
 * ============================================
 */

class AfricoreSDK {
    constructor() {
        this.base = window.AFRICORE_BRIDGE || {};
    }

  pay({ amount, description, appId }) {
    return fetch("/api/miniapp/pay", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + localStorage.getItem("token")
        },
        body: JSON.stringify({ amount, description, appId })
    }).then(res => res.json());
} 

    // =============================
    // GET USER INFO
    // =============================
    getUser() {
        return new Promise((resolve, reject) => {
            if (this.base.getUser) {
                resolve(this.base.getUser());
            } else {
                reject("User data not available");
            }
        });
    }

    // =============================
    // GET WALLET
    // =============================
    getWallet() {
        return new Promise((resolve, reject) => {
            if (this.base.getWallet) {
                resolve(this.base.getWallet());
            } else {
                reject("Wallet data not available");
            }
        });
    }

    // =============================
    // MAKE PAYMENT
    // =============================
    pay({ amount, description }) {
        return new Promise((resolve, reject) => {
            if (this.base.pay) {
                this.base.pay({ amount, description, callback: resolve });
            } else {
                reject("Payment bridge not available");
            }
        });
    }

    // =============================
    // SEND NOTIFICATION
    // =============================
    notify(message) {
        if (this.base.notify) {
            this.base.notify(message);
        }
    }

    // =============================
    // CLOSE APP
    // =============================
    close() {
        if (this.base.close) {
            this.base.close();
        }
    }
}

// Export global
window.Africore = new AfricoreSDK();
