using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Agent : MonoBehaviour
{
    public enum Direction
    {
        Up,
        Down,
        Left,
        Right
    }

    public GameObject MapObj;
    public GameObject CurrentCell;
    public int Health;

    private Vector2 _pos;
    private int _points;
    private int _ammunition;
    private Direction _direction;

    // Use this for initialization
    void Start()
    {
        Health = 100;
        _points = 0;
        _pos = Vector2.zero;
        _ammunition = 5;
        _direction = Direction.Up;

        StartCoroutine(CheckNextMove());
    }

    IEnumerator CheckNextMove()
    {
        while (Health > 0)
        {
            yield return new WaitForSeconds(1);
        }
    }

    void Move()
    {
        _points--;
        GameObject tmpCell = null;

        switch (_direction)
        {
            case Direction.Up:
                tmpCell = MapObj.GetComponent<Map>().GetCell((int)(_pos.x), (int)(_pos.y + 1));
                break;
            case Direction.Down:
                tmpCell = MapObj.GetComponent<Map>().GetCell((int)(_pos.x), (int)(_pos.y));
                break;
            case Direction.Left:
                tmpCell = MapObj.GetComponent<Map>().GetCell((int)(_pos.x), (int)(_pos.y));
                break;
            case Direction.Right:
                tmpCell = MapObj.GetComponent<Map>().GetCell((int)(_pos.x), (int)(_pos.y));
                break;
            default:
                break;
        }

        if(CurrentCell)
        {
            CurrentCell = tmpCell;
            transform.position = new Vector3(CurrentCell.transform.position.x, transform.position.y, CurrentCell.transform.position.z);
        }
    }

    void TurnRight()
    {
        _points--;

        transform.Rotate(Vector3.up, 90f);
        switch(_direction)
        {
            case Direction.Up:
                _direction = Direction.Right;
                break;
            case Direction.Down:
                _direction = Direction.Left;
                break;
            case Direction.Left:
                _direction = Direction.Up;
                break;
            case Direction.Right:
                _direction = Direction.Down;
                break;
            default:
                break;
        }
    }

    void TurnLeft()
    {
        _points--;

        transform.Rotate(Vector3.up, -90f);
        switch (_direction)
        {
            case Direction.Up:
                _direction = Direction.Left;
                break;
            case Direction.Down:
                _direction = Direction.Right;
                break;
            case Direction.Left:
                _direction = Direction.Down;
                break;
            case Direction.Right:
                _direction = Direction.Up;
                break;
            default:
                break;
        }
    }

    void Climb()
    {
        _points--;
        if (_pos.x == 0 && _pos.y == 0)
        {

        }
        else
        {
            Debug.Log("Cant climb here: [" + _pos.x + "," + _pos.y + "]");
        }
    }

    void Grab()
    {
        _points--;
    }

    void Shoot()
    {
        _points--;
        _points -= 10;
        int damage = Random.Range(20, 51);

        //TODO: send damage foward
    }

    void Damage(int damage)
    {
        Health -= damage;
        _points -= damage;

        if (Health <= 0)
        {
            _points -= 1000;
            GM.GetInstance().GameRunning = false;
        }
    }
}
