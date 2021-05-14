import React from "react"
import DataTable from 'react-data-table-component';
import Select from 'react-select'
import {DebounceInput} from 'react-debounce-input';
import {Button} from "antd";

class ShowSearch extends React.Component {
  state = {
    filterText: '',
    searchResults: [],
    dbShow: null,
    selectedNetwork: null,
    isLoading: true
  }

  onTextChange = (e) => {
    const value = e.target.value;
    this.setState({filterText: value});
    this.getPossibleMatches(value);
  }

  getPossibleMatches = (title) => {
    const url = `/admin/matching/possible_matches?title=${encodeURIComponent(title)}`
    fetch(url)
      .then(response => response.json())
      .then(data => {
        const programs = data.map((match) => match.program);
        this.setState({ searchResults: programs })
      });
  }

  onSelectItem = (data) => {
    console.log(data)
  }

  onSelect = (selected) => {
    this.setState({selectedNetwork: selected })
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

  render() {
    const {filterText, searchResults, } = this.state;
    const customStyles = {
      rows: {
        style: {
          minHeight: 100,
        }
      },
      cells: {
        style: {
          minWidth: 75
        }
      },
    };

    const inputStyle = {
      height: 37,
      borderRadius: 3,
      borderTopLeftRadius: 5,
      borderBottomLeftRadius: 5,
      borderTopRightRadius: 0,
      borderBottomRightRadius: 0,
      marginBottom: '2em',
      border: '1px solid #e5e5e5',
      padding: '0 32px 0 16px',
    };

    const columns = [
      {
        name: 'Poster',
        selector: 'preferred_image_uri',
        cell: (row) => {
          return row.preferredImage && <img src={row.preferredImage.uri} height={100} />
        }
      },
      {
        name: 'Title',
        selector: 'title',
        compact: true,
        sortable: true,
      },
      {
        name: 'Year',
        selector: 'releaseYear',
        sortable: true,
        compact: true
      },
      {
        name: 'Select',
        sortable: false,
        cell: (row) => {
          return <Button onClick={this.props.onClick.bind(this, row)}>Add</Button>
        }
      }
    ]

    const {networks} = this.props;
    const {selectedShow, dbShow, isLoading, selectedNetwork} = this.state;
    const options = networks && networks.map((network) => {
      return { label: network.display_name, value: network.id }
    })

    return (
      <div>
        <DebounceInput
          minLength={2}
          debounceTimeout={300}
          id="search"
          type="text"
          placeholder="Search Gracenote"
          value={filterText}
          onChange={this.onTextChange}
          style={inputStyle}
        />
        <DataTable
          fixedHeader
          striped
          conditionalRowStyles={this.conditionalRowStyles()}
          highlightOnHover
          columns={columns}
          data={searchResults}
          onRowClicked={this.onSelectItem}
          pagination
          paginationPerPage={20}
          subHeader
          customStyles={customStyles}
        />
      </div>
    )
  }
}

export default ShowSearch;
