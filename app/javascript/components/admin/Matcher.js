import React from "react";
import ShowList from "./matcher/ShowList";
import OriginalsMatchList from "./matcher/OriginalsMatchList";
import NetworksMatchList from "./matcher/NetworksMatchList";
import Importer from "./matcher/Importer";

class Matcher extends React.Component {
  ORIGINALS_CATEGORY = 'Originals'; // streaming
  NETWORKS_CATEGORY = 'Networks'; // original tv network
  IMPORTER_CATEGORY = 'Importer'; // Import new shows

  state = {
    shows: [],
    unmatched: [],
    matched: [],
    possibleMatches: [],
    networks: [],
    selectedId: null,
    selectedTmsId: null,
    selectedShow: null,
    category: this.IMPORTER_CATEGORY
  }

  componentDidMount() {
    this.getData();
    this.getNetworks();
  }

  getData = () => {
    const { category } = this.state;
    let unmatched = [];
    let matched = [];
    const url = category === this.ORIGINALS_CATEGORY ? '/admin/matching/shows' : '/admin/matching/networks/shows'

    fetch(url)
      .then(response => response.json())
      .then(data => {
        this.setState({ unmatched, matched, shows: data });
      });
  }

  getNetworks = () => {
    fetch('/admin/matching/networks')
      .then(response => response.json())
      .then(data => {
        this.setState({ networks: data });
      });
  }

  getPossibleMatches = (selectedShow, selectedId, title, selectedTmsId) => {
    const url = `/admin/matching/possible_matches?title=${encodeURIComponent(title)}`
    fetch(url)
      .then(response => response.json())
      .then(data => {
        const programs = data.map((match) => match.program);
        this.setState({ selectedShow, selectedId, selectedTmsId, selectedTitle: title, possibleMatches: programs })
      });
  }

  saveMatch = (id, tmsId) => {
    const {selectedShow, selectedId, selectedTitle, selectedTmsId} = this.state;

    const url = '/admin/matching/match'
    const data = {
      id: id,
      tms_id: tmsId
    }

    fetch(url, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    }).then(response => response.json())
    .then(data => {
      this.getData();
      this.getPossibleMatches(selectedShow, selectedId, selectedTitle, tmsId);
    });
  }

  assignNetwork = ({seriesId, networkId, tmsId}) => {
    const url = '/admin/matching/networks/match'
    const data = {
      seriesId,
      networkId,
      tmsId
    }

    fetch(url, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    }).then(response => response.json())
    .then(data => {
      this.getData();
    });
  }

  changeCategory = (category) => {
    this.setState({category, shows: [], selectedShow: null}, () => {
      this.getData();
    });
  }

  render () {
    const {
      category,
      matched,
      unmatched,
      shows,
      possibleMatches,
      selectedId,
      selectedTitle,
      selectedTmsId,
      selectedShow,
      networks
    } = this.state;

    return (
      <div>
      <div id='matcher' style={{
          display: 'flex',
          width: '100%'
        }}>
        <div className="originals" style={{width: '40%' }}>
          <div>
            <button
              disabled={category === 'Originals'}
              onClick={this.changeCategory.bind(this, 'Originals')}
              >
              Streaming Shows
            </button>
            <button
              disabled={category === 'Networks'}
              onClick={this.changeCategory.bind(this, 'Networks')}
              >
              Original Networks
            </button>
            <button
              disabled={category === 'Importer'}
              onClick={this.changeCategory.bind(this, 'Importer')}
              >
              Importer
            </button>
          </div>

          { category !== this.IMPORTER_CATEGORY &&
            <ShowList
              title={category}
              shows={shows}
              getPossibleMatches={this.getPossibleMatches}
              selectedId={selectedId}
              onCategoryChange={this.changeCategory}
            />
        }
        </div>
        <div className="matches">
          { category === this.ORIGINALS_CATEGORY &&
            <OriginalsMatchList
              matches={possibleMatches}
              saveMatch={this.saveMatch}
              showId={selectedId}
              showTitle={selectedTitle}
              selectedTmsId={selectedTmsId}
            />
          }
          { category === this.NETWORKS_CATEGORY &&
            <NetworksMatchList
              assignNetwork={this.assignNetwork}
              show={selectedShow}
              networks={networks}
            />
          }
        </div>
      </div>
      <div>
        { category === this.IMPORTER_CATEGORY &&
          <Importer
            assignNetwork={this.assignNetwork}
            show={selectedShow}
            networks={networks}
          />
        }
      </div>
      </div>
    );
  }
}

export default Matcher
