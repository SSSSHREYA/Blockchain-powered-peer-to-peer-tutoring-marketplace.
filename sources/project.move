module Tutoring::Marketplace {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a tutoring offer
    struct TutoringOffer has key, store {
        tutor: address,
        subject: vector<u8>,
        price: u64,
    }

    /// Tutors can offer a session with a subject and price
    public fun offer_tutoring(tutor: &signer, subject: vector<u8>, price: u64) {
        let offer = TutoringOffer {
            tutor: signer::address_of(tutor),
            subject,
            price,
        };
        move_to(tutor, offer);
    }

    /// Students book a session by paying the tutor
    public fun book_session(student: &signer, tutor_addr: address, amount: u64) acquires TutoringOffer {
        let offer = borrow_global<TutoringOffer>(tutor_addr);
        assert!(amount == offer.price, 1); // Ensure correct amount

        let payment = coin::withdraw<AptosCoin>(student, amount);
        coin::deposit<AptosCoin>(tutor_addr, payment);
    }
}
