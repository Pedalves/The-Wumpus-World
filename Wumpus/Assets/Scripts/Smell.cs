using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Smell : MonoBehaviour, CellEffect
{
    // Use this for initialization
    void Start ()
    {
		
	}

    public void Action()
    {
        GM.GetInstance().GetAgent().Perceive("Smell");
    }

    public void Interact()
    {

    }
}
