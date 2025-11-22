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

      it 'user作成時に関連（smoking_setting,abstinence_session）も作成・保存される' do
        expect {
          user = FactoryBot.create(:user)
          expect(user.smoking_setting).to be_present
          expect(user.abstinence_sessions.size).to eq(1)
          expect(user.abstinence_sessions.first.started_at).to be_within(1.second).of(user.smoking_setting.quit_start_datetime)
        }.to change(SmokingSetting, :count).by(1)
         .and change(AbstinenceSession, :count).by(1)
      end  

      it 'ネスト属性でsmoking_setting、abstinence_sessionを作成される' do
        attrs = FactoryBot.attributes_for(:smoking_setting)
        user = FactoryBot.build(:user, smoking_setting_attributes: attrs)
        expect(user.save).to be true
        expect(user.smoking_setting).to be_present
        expect(user.abstinence_sessions.size).to eq(1)
        expect(user.abstinence_sessions.first.started_at).to be_within(1.second).of(user.smoking_setting.quit_start_datetime)
      end

      context '新規登録がうまくいかないとき' do

        it 'nicknameが空では登録できない' do
          user = FactoryBot.build(:user, nickname: '')
          user.valid?
          expect(user.errors.full_messages).to include("Nickname を入力してください")
        end

        it 'nicknameが1文字以下では登録できない' do
          user = FactoryBot.build(:user, nickname: 'a')
          user.valid?
          expect(user.errors.full_messages).to include("Nickname は2文字以上で入力してください")
        end

        it 'nicknameが31文字以上では登録できない' do
          user = FactoryBot.build(:user, nickname: 'a' * 31)
          user.valid?
          expect(user.errors.full_messages).to include("Nickname は30文字以内で入力してください")
        end

        [      
          "\t",     
          "\n",     
          "\t\n",  
        ].each do |invalid_nickname|
          it "#{invalid_nickname.inspect}は無効なニックネームである" do
            user = FactoryBot.build(:user, nickname: invalid_nickname)
            user.valid?
            expect(user.errors.full_messages).to include("Nickname は空白のみにはできません")
          end
        end
      end
  end
 end
end
 
