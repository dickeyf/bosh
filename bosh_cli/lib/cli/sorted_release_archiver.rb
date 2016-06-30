module Bosh::Cli
  class SortedReleaseArchiver
    def initialize(dir)
      @dir = dir
    end

    def archive(destination_file)
      Dir.chdir(@dir) do
        ordered_release_files = Bosh::Common::Release::ReleaseDirectory.new('.').ordered_release_files
        success = Kernel.system('tar', '--force-local', '-C', @dir, '-pczf', destination_file, *ordered_release_files)
        if !success
          raise InvalidRelease, 'Cannot create release tarball'
        end
      end
    end
  end
end
