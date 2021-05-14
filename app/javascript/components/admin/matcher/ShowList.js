import React from "react"
import styled from 'styled-components';
import DataTable from 'react-data-table-component';
import Select from 'react-select'


const options = [
  { value: 'all', label: 'All' },
  { value: 'unmatched', label: 'Unmatched' },
  { value: 'matched', label: 'Matched' }
];

const columns = {
  Originals: [
    {
      name: 'Title',
      selector: 'title',
      sortable: true,
      cell: (row) => {
      const style = { height: 10, width: 10, marginRight: 10, borderRadius: '50%', display: 'inline-block', backgroundColor: row.tmsId ? '#1aab27' : '#4d4d4d' };
        return <p><span style={style}></span> {row.title}</p>
      }
    },
    {
      name: 'Type',
      selector: 'entityType',
      sortable: false,
      compact: true
    },
    {
      name: 'Network',
      selector: 'original_streaming_network',
      sortable: true,
      compact: true,
      cell: (row) => {
        return <img src={`/images/${row.original_streaming_network}.svg`} width={60} />
      }

    }
  ],
  Networks: [
    {
      name: 'Poster',
      selector: 'preferred_image_uri',
      compact: true,
      cell: (row) => {
        return <img src={row.preferred_image_uri} height={100} />
      }
    },
    {
      name: 'Title',
      selector: 'title',
      compact: false,
      sortable: true,
    },
    {
      name: 'releaseYear',
      selector: 'releaseYear',
      sortable: true,
      compact: true
    },
    {
      name: 'Episode Count',
      selector: 'episodes_count',
      sortable: true,
      compact: true,
    },
    {
      name: 'Popularity Score',
      selector: 'popularity_score',
      sortable: true,
      compact: true,
    }
  ]
}

const styles = {
  root: {
    width: '100%',
  }
}

const TextField = styled.input`
  height: 37px;
  width: 80%;
  border-radius: 3px;
  border-top-left-radius: 5px;
  border-bottom-left-radius: 5px;
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
  border: 1px solid #e5e5e5;
  padding: 0 32px 0 16px;

  &:hover {
    cursor: pointer;
  }
`;

const customStyles = {
  rows: {
    style: {
      minHeight: null
    }
  }
};

const FilterComponent = ({ filterText, onFilter, onClear, onToggle, title }) => (
  <div style={{display: 'flex', flexDirection: 'row', width: '100%'}}>
    { title === 'Originals' &&
      <div style={{width: '25%'}}>
        <Select options={options} onChange={onToggle} style={{width: '100%'}}/>
      </div>
    }

    <div style={{width: '60%'}}>
      <TextField id="search" type="text" placeholder="Filter By Name" value={filterText} onChange={onFilter} />
    </div>

  </div>
);

class ShowList extends React.Component {
  state = {
    filterText: '',
    matchFilter: 'all'
  }

  conditionalRowStyles = () => {
    const {selectedId} = this.props;

    return [
      {
        when: row => row.id === selectedId,
        style: {
          backgroundColor: '#e3f2fd !important',
          '&:hover': {
            cursor: 'pointer',
          },
        },
      },
    ];
  }

  onSelectItem = (show, event) => {
    const {getPossibleMatches} = this.props;
    this.setState({ selectedId: show.id });
    getPossibleMatches(show, show.id, show.title, show.tmsId);
  }

  render () {
    const {shows, selectedId, title} = this.props;
    const {filterText, matchFilter} = this.state;

    const filteredShows = shows.filter(show => {
      let matchedOrUnmatchedFilter;

        switch(matchFilter) {
          case 'all':
            matchedOrUnmatchedFilter = true;
            break;
          case 'matched':
            matchedOrUnmatchedFilter = !!show.tmsId;
            break;
          case 'unmatched':
            matchedOrUnmatchedFilter = !show.tmsId;
            break;
        }

      const titleFilter = show.title && show.title.toLowerCase().includes(filterText.toLowerCase());
      return matchedOrUnmatchedFilter && titleFilter;
    });

    return (
      <div style={styles.root}>
        <DataTable
          fixedHeader
          striped
          customStyles={customStyles}
          conditionalRowStyles={this.conditionalRowStyles()}
          highlightOnHover
          columns={columns[title]}
          data={filteredShows}
          onRowClicked={this.onSelectItem}
          pagination
          paginationPerPage={20}
          subHeader
          subHeaderComponent={<FilterComponent
            filterText={filterText}
            onFilter={e => this.setState({ filterText: e.target.value})}
            onToggle={e => this.setState({ matchFilter: e.value})}
            title={title}
          />}
        />
      </div>
    );
  }
}

export default ShowList
