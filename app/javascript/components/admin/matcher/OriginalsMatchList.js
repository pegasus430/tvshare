// This will match a show with a TMS ID

import React from "react"
import PropTypes from "prop-types"
import DataTable from 'react-data-table-component';

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
  }
}

class OriginalsMatchList extends React.Component {
  onClickSaveMatch = (tmsId) => {
    const {saveMatch, showId} = this.props;
    saveMatch(showId, tmsId);
  }
  render () {
    const {matches, showTitle, selectedTmsId} = this.props;
    const columns = [
      {
        name: 'Poster',
        cell: row => <img height="250px" alt={row.title} src={row.preferredImage.uri} />,
        minWidth: 250,
        compact: true
      },
      {
        name: 'Title & Description',
        selector: 'title',
        sortable: true,
        cell: row => <div><h4>{row.title}</h4><p>{row.shortDescription}</p></div>,
      },
      {
        name: 'Year',
        selector: 'releaseYear',
        sortable: true
      },
      {
        name: 'Genres',
        selector: 'genres',
        cell: row => <div>{row.genres && row.genres.map((genre, i) => <div key={i}>{genre}</div>)}</div>,
      },
      {
        name: 'Type',
        selector: 'entityType',
        sortable: true
      },
      {
        name: 'Match',
        button: true,
        cell: (row) => <button type="button" onClick={this.onClickSaveMatch.bind(this, row.tmsId)} disabled={selectedTmsId && selectedTmsId === row.tmsId}>Match</button>,
      },
    ];

    return (
      <div style={styles.root}>
        { !!matches.length && <DataTable
          fixedHeader
          striped
          highlightOnHover
          title={`Matches for ${showTitle}`}
          columns={columns}
          data={matches}
          pagination
          customStyles={customStyles}
        />}
      </div>
    );
  }
}

export default OriginalsMatchList;
