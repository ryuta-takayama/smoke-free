require 'rails_helper'

RSpec.describe User, type: :model do
 
  describe 'ユーザー新規登録' do
    context '新規登録がうまくいくとき' do

    it '必要な情報が全て存在すれば登録できる' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it 'passwordが6文字以上であれば登録できる' do
      user = FactoryBot.build(:user, password: 'abc123', password_confirmation: 'abc123')
      expect(user).to be_valid
    end

    it 'passwordが英字と数字の両方を含んでいれば登録できる' do
      user = FactoryBot.build(:user, password: 'abc123', password_confirmation: 'abc123')
      expect(user).to be_valid
    end

    [
       'aa',    
       'ＡＡ',   
       '11',    
       '１１',   
       '太郎',  
       'ab　',  
       '　ab',  
       'a b' 
    ].each do |valid_nickname|
      it "#{valid_nickname.inspect}は有効なニックネームである" do
      user = FactoryBot.build(:user, nickname: valid_nickname)
      expect(user).to be_valid
      end
     end

     it 'ageが20以上であれば登録できる' do
       user = FactoryBot.build(:user, age: 25)
       expect(user).to be_valid
     end

     it 'reason_to_quitが存在すれば登録できる' do
       user = FactoryBot.build(:user, reason_to_quit: 'health')
       expect(user).to be_valid
     end
     
     it 'enum reason_to_quitの値が有効であれば登録できる' do
        valid_reasons = ['health','money','family','work','other']
        valid_reasons.each do |reason|
          user = FactoryBot.build(:user, reason_to_quit: reason)
          expect(user).to be_valid
        end
      end

      it 'emailは大文字小文字と空白を区別しない' do
        user = FactoryBot.create(:user, email: ' TEST@Example.com ')
        user.reload
        expect(user.email).to eq('test@example.com')
      end

      
  end
 end
end
 
