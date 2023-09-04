require "active_record"

module RefineRollback
  refine ::ActiveRecord::ConnectionAdapters::TransactionManager do
    def rollback_transaction(transaction = nil)
      @connection.lock.synchronize do
        transaction ||= @stack.pop
        transaction.try(:rollback) && transaction.rollback_records
      end
    end
  end
end

RSpec.configure do |config|
  using RefineRollback
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
