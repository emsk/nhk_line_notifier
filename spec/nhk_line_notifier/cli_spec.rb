RSpec.describe NhkLineNotifier::CLI do
  let(:help) do
    <<-EOS
Commands:
  #{command} execute -a, --area=AREA -d, --date=N -l, --line-key=LINE_KEY -n, --nhk-key=NHK_KEY -s, --service=SERVICE  # Search NHK programs and notify via LINE Notify
  #{command} help [COMMAND]                                                                                            # Describe available commands or one specific command
  #{command} version, -v, --version                                                                                    # Print the version

    EOS
  end

  shared_examples_for 'a `help` command' do
    before do
      expect(File).to receive(:basename).with($PROGRAM_NAME).and_return(command).at_least(:once)
    end

    it { is_expected.to output(help).to_stdout }
  end

  describe '.start' do
    let(:command) { 'nhk_line_notifier' }

    subject { -> { described_class.start(thor_args) } }

    context 'given `version`' do
      let(:command) { 'nhk_line_notifier' }
      let(:thor_args) { %w[version] }
      it { is_expected.to output("#{command} #{NhkLineNotifier::VERSION}\n").to_stdout }
    end

    context 'given `--version`' do
      let(:command) { 'nhk_line_notifier' }
      let(:thor_args) { %w[--version] }
      it { is_expected.to output("#{command} #{NhkLineNotifier::VERSION}\n").to_stdout }
    end

    context 'given `-v`' do
      let(:command) { 'nhk_line_notifier' }
      let(:thor_args) { %w[-v] }
      it { is_expected.to output("#{command} #{NhkLineNotifier::VERSION}\n").to_stdout }
    end

    context 'given `help`' do
      let(:thor_args) { %w[help] }
      it_behaves_like 'a `help` command'
    end

    context 'given `--help`' do
      let(:thor_args) { %w[--help] }
      it_behaves_like 'a `help` command'
    end

    context 'given `-h`' do
      let(:thor_args) { %w[-h] }
      it_behaves_like 'a `help` command'
    end

    context 'given `h`' do
      let(:thor_args) { %w[h] }
      it_behaves_like 'a `help` command'
    end

    context 'given `he`' do
      let(:thor_args) { %w[he] }
      it_behaves_like 'a `help` command'
    end

    context 'given `hel`' do
      let(:thor_args) { %w[hel] }
      it_behaves_like 'a `help` command'
    end

    context 'given `help execute`' do
      let(:thor_args) { %w[help execute] }
      let(:help) do
        <<-EOS
Usage:
  #{command} execute -a, --area=AREA -d, --date=N -l, --line-key=LINE_KEY -n, --nhk-key=NHK_KEY -s, --service=SERVICE

Options:
  -a, --area=AREA          
  -s, --service=SERVICE    
  -d, --date=N             
  -n, --nhk-key=NHK_KEY    
  -l, --line-key=LINE_KEY  
  -w, [--word=WORD]        

Search NHK programs and notify via LINE Notify
        EOS
      end
      it_behaves_like 'a `help` command'
    end

    context 'given `help version`' do
      let(:thor_args) { %w[help version] }
      let(:help) do
        <<-EOS
Usage:
  #{command} version, -v, --version

Print the version
        EOS
      end
      it_behaves_like 'a `help` command'
    end

    context 'given `help help`' do
      let(:thor_args) { %w[help help] }
      let(:help) do
        <<-EOS
Usage:
  #{command} help [COMMAND]

Describe available commands or one specific command
        EOS
      end
      it_behaves_like 'a `help` command'
    end

    context 'given `abc`' do
      let(:thor_args) { %w[abc] }
      it { is_expected.to output(%(Could not find command "abc".\n)).to_stderr }
    end

    context 'given `helpp`' do
      let(:thor_args) { %w[helpp] }
      it { is_expected.to output(%(Could not find command "helpp".\n)).to_stderr }
    end
  end
end
