// This will match a show with a TMS ID

import React from "react"
import PropTypes from "prop-types"
import Select from 'react-select'

const customStyles = {
  rows: {
    style: {
      minHeight: 250,
    }
  },
};

const styles = {
  root: {
    width: '100%',
    display: 'flex',
  }
}

class NetworksMatchList extends React.Component {
  state = {
    selectedNetwork: null
  }

  onClickSaveMatch = (seriesId) => {
    const {selectedNetwork} = this.state;
    const {assignNetwork} = this.props;
    assignNetwork({seriesId, networkId: selectedNetwork});
  }

  onSelect = (selected) => {
    console.log(selected)
    this.setState({selectedNetwork: selected.value })
  }

  componentDidUpdate(prevProps) {
    if (this.props.show && prevProps.show && this.props.show.tmsId !== prevProps.show.tmsId) {
      // reset network selection
      this.setState({ selectedNetwork: null })
    }
  }

  render () {
    const {matches, showTitle, selectedTmsId, show, networks} = this.props;
    const {selectedNetwork} = this.state;
    const options = networks.map((network) => {
      return { label: network.display_name, value: network.id }
    })

    if (!show) {
      return ''
    }

    return (
      <div style={styles.root}>
        <div style={{marginRight: 25}}>
          <img height="250px" alt={show.title} src={show.preferred_image_uri} />
        </div>
        <div>
          <h3>{show.title}</h3>
          <p>{show.releaseYear}</p>
          <p>{show.tmsId}</p>
          <p>{show.series_id}</p>
          <p>{show.shortDescription}</p>
          <div>{show.genres && show.genres.map((genre, i) => <div key={i}>{genre}</div>)}</div>
          <div>
            <Select options={options} onChange={this.onSelect} value={selectedNetwork && selectedNetwork.value}/>
          </div>
          <div>
            <button
              type="button"
              disabled={!selectedNetwork}
              onClick={this.onClickSaveMatch.bind(this, show.seriesId)}
              style={{marginTop: 10}}
            >
              Match
            </button>
          </div>
        </div>
      </div>
    );
  }
}

export default NetworksMatchList;

/*

  genres,
  title,
  poster,
  releaseYear,
  episodes_count,
  longDescription,
  origAirDate,
  tmsId,

*/
