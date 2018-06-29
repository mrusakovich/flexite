module Flexite
  class Diff
    class ShowService
      def call
        Flexite.cache.fetch("#{Flexite.state_digest}-diffdigest") do
          Flexite.cache.delete_matched(/-diffdigest/)
          f = File.open(File.join(Rails.root, 'tmp', 'nodes.json'))
          r = Diff.post(:check, nil, { token: 'test', tree: JSON.parse(f.read) }.to_json)
          h = JSON.parse(r.body, symbolize_names: true)
          Flexite.cache.write('stage-name-treechecksum', h[:checksum])
          h[:diffs]
        end
      end
    end
  end
end
