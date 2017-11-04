using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gold : MonoBehaviour,CellEffect
{
	// Use this for initialization
	void Start ()
    {
		
	}

    public void Action()
    {
        GM.GetInstance().GetAgent().Perceive("Shiny");
    }

    public void Interact()
    {
        GM.GetInstance().GetAgent().UpdatePoints(1000);
        Destroy(gameObject);
    }

    public void Damage(int damage)
    {

    }
}
