require 'rails_helper'

describe TremendousPNG do
  describe ".cleaned_text" do
    before do
      stub_const("TremendousPNG::ROWS", 2)
      stub_const("TremendousPNG::COLS", 2)
    end

    it 'returns the string as nested array' do
      cleaned_text = TremendousPNG.cleaned_text("asdf")
      expect(cleaned_text).to eq [["a", "s"], ["d", "f"]]
    end

    it 'removes special characters' do
      cleaned_text = TremendousPNG.cleaned_text("as*df!")
      expect(cleaned_text).to eq [["a", "s"], ["d", "f"]]
    end

    it 'returns lowercase letters' do
      cleaned_text = TremendousPNG.cleaned_text("ASDF")
      expect(cleaned_text).to eq [["a", "s"], ["d", "f"]]
    end

    it 'fills with noise' do
      expect(SecureRandom).to receive(:hex).with(3).and_return('sdfxxx')
      expect(SecureRandom).to receive(:rand).with(3).and_return(2)
      cleaned_text = TremendousPNG.cleaned_text("a")
      expect(cleaned_text).to eq [["s", "d"], ["a", "f"]]
    end

    it 'returns the first part of the string when it is too long' do
      cleaned_text = TremendousPNG.cleaned_text("something")
      expect(cleaned_text).to eq [["s", "o"], ["m", "e"]]
    end
  end
end
