require 'rails_helper'
require 'spec_helper'

RSpec.describe NotificationsController do
  describe '#update' do
    context 'when notification read_at is updated' do
      let(:user) { create(:user) }
      let!(:notification) { create(:notification, user: user) }
      before do
        sign_in(user, scope: :user)
        put 'update', params: { id: notification.id }
      end
      it 'sets read_at' do
        expect(notification.reload.read_at).to be_present
      end
    end
  end
end
