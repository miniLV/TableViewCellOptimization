import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableHighlight
} from 'react-native';
import Popover from './Popover'

export default class TestDemo extends Component {
    constructor(props){
        super(props);
        this.state={
            isVisible: false,
            buttonRect: {}
        }
    }

    showPopover=()=> {
        this.refs.button.measure((ox, oy, width, height, px, py) => {
            this.setState({
                isVisible: true,
                buttonRect: {x: px, y: py, width: width, height: height}
            });
            alert('showPopover')
        });
    }

    closePopover=()=> {
        alert('closePopover')
        this.setState({isVisible: false});
    }
    render() {
        return (
            <View style={styles.container}>
                <TouchableHighlight ref='button' style={styles.button} onPress={this.showPopover}>
                    <Text style={styles.buttonText}>Press me haha</Text>
                </TouchableHighlight>

                {/*<Text>Press me 123</Text>*/}
                <Popover
                    isVisible={this.state.isVisible}
                    fromRect={this.state.buttonRect}
                    onClose={this.closePopover}>
                    <Text>wahaha!I'm the content of this popover!</Text>
                </Popover>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
    button: {
        borderRadius: 4,
        padding: 10,
        marginLeft: 10,
        marginRight: 10,
        backgroundColor: '#ccc',
        borderColor: '#333',
        borderWidth: 1,
        width:100,
        marginTop:200,
    },
    buttonText: {
        color:'red'
    }
});

AppRegistry.registerComponent('TestDemo', () => TestDemo);