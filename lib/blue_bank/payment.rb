module BlueBank
  class Payment
    def initialize(id:, account:, client:, json: nil)
      @id, @account, @client, @json = id, account, client, json
    end

    def pending?
      status == "Pending"
    end

    def instructed?
      status == "Completed"
    end

    def reload!
      @json = nil
      !!json
    end

    def status
      json.fetch("paymentStatus")
    end

    private

    def json
      @json ||= client.get("/accounts/#{account.id}/payments/#{id}").first
    end

    attr_reader :id, :account, :client
  end
end
