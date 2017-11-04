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
    public bool Controllable;
    public int Points;

    private Vector2 _pos;
    private int _ammunition;
    private Direction _direction;

    // Use this for initialization
    void Start()
    {
        Health = 100;
        Points = 0;
        _pos = Vector2.zero;
        _ammunition = 5;
        _direction = Direction.Up;

        StartCoroutine(CheckNextMove());
    }

    private void Update()
    {
        if (Controllable && GM.GetInstance().GetGameRunning())
        {
            if (Input.GetKeyDown(KeyCode.UpArrow))
            {
                Move();
            }
            else if (Input.GetKeyDown(KeyCode.LeftArrow))
            {
                TurnLeft();
            }
            else if (Input.GetKeyDown(KeyCode.RightArrow))
            {
                TurnRight();
            }
            else if (Input.GetKeyDown(KeyCode.C))
            {
                Climb();
            }
            else if (Input.GetKeyDown(KeyCode.G))
            {
                Grab();
            }
            else if (Input.GetKeyDown(KeyCode.Space))
            {
                Shoot();
            }
        }
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
        Points--;
        Cell tmpCell = null;
        Vector2 tmpPos = _pos;

        switch (_direction)
        {
            case Direction.Up:
                tmpPos = new Vector2(_pos.x, _pos.y + 1);
                tmpCell = MapObj.GetComponent<Map>().GetCell((int)(tmpPos.x), (int)(tmpPos.y));
                break;
            case Direction.Down:
                tmpPos = new Vector2(_pos.x, _pos.y - 1);
                tmpCell = MapObj.GetComponent<Map>().GetCell((int)(tmpPos.x), (int)(tmpPos.y));
                break;
            case Direction.Left:
                tmpPos = new Vector2(_pos.x - 1, _pos.y);
                tmpCell = MapObj.GetComponent<Map>().GetCell((int)(tmpPos.x), (int)(tmpPos.y));
                break;
            case Direction.Right:
                tmpPos = new Vector2(_pos.x + 1, _pos.y);
                tmpCell = MapObj.GetComponent<Map>().GetCell((int)(tmpPos.x), (int)(tmpPos.y));
                break;
            default:
                break;
        }

        if(tmpCell)
        {
            CurrentCell = tmpCell.gameObject;
            CurrentCell.GetComponent<Cell>().AgentIn();

            transform.position = new Vector3(CurrentCell.transform.position.x, transform.position.y, CurrentCell.transform.position.z);
            _pos = tmpPos;
        }
    }

    void TurnRight()
    {
        Points--;

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
        Points--;

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
        Points--;
        if (_pos.x == 0 && _pos.y == 0)
        {
            GM.GetInstance().SetGameRunning(false);
        }
        else
        {
            Debug.Log("Cant climb here: [" + _pos.x + "," + _pos.y + "]");
        }
    }

    void Grab()
    {
        Points--;

        //CurrentCell
    }

    void Shoot()
    {
        if(_ammunition > 0)
        {
            Points--;
            Points -= 10;
            _ammunition--;
            int damage = Random.Range(20, 51);

            //TODO: send damage foward
        }
        else
        {
            Debug.Log("No ammo");
        }
    }

    public void ReceiveDamage(int damage, bool wumpus = false)
    {
        Health -= damage;
        if(wumpus)
        {
            Points -= damage;
        }

        if (Health <= 0)
        {
            Points -= 1000;
            GM.GetInstance().SetGameRunning(false);
        }
    }

    public void Perceive(string str)
    {
        Debug.Log(str);
    }
}
